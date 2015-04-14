# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'
describe GroupDecorator, :draper_with_helpers do
  include Rails.application.routes.url_helpers

  let(:model) { double('model') }
  let(:decorator) { GroupDecorator.new(model) }
  let(:context) { double('context') }
  subject { decorator }

  describe 'possible roles' do
    let(:model) { groups(:top_group) }
    its(:possible_roles) do
      should eq [Group::TopGroup::Leader,
                 Group::TopGroup::LocalGuide,
                 Group::TopGroup::Secretary,
                 Group::TopGroup::LocalSecretary,
                 Group::TopGroup::Member,
                 Role::External]
    end
  end

  describe 'selecting attributes' do
    before do
      allow(subject).to receive_messages(h: context)
      allow(model).to receive_message_chain(:class, :attr_used?) { |val| val }
    end

    it '#used_attributes selects via .attr_used?' do
      expect(model.class).to receive(:attr_used?).twice
      expect(subject.used_attributes(:foo, :bar)).to eq %w(foo bar)
    end

    it '#modifiable_attributes we can :modify_superior' do
      expect(context).to receive(:can?).with(:modify_superior, subject).and_return(true)
      expect(subject.modifiable_attributes(:foo, :bar)).to eq %w(foo bar)
    end

    it '#modifiable_attributes filters attributes if we cannot :modify_superior' do
      allow(model.class).to receive_messages(superior_attributes: [:foo])
      expect(context).to receive(:can?).with(:modify_superior, subject).and_return(false)
      expect(subject.modifiable_attributes(:foo, :bar)).to eq %w(bar)
    end
  end

end
