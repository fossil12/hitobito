# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Export::Pdf::Invoice
  class InvoiceInformation < Section

    def render
      bounding_box([0, 640], width: bounds.width, height: 80) do
        table(information, cell_style: { borders: [], padding: [1, 20, 0, 0] })
      end
    end

    private

    def information
      [
        [I18n.t('invoices.pdf.invoice_number') + ':',
         invoice.sequence_number],
        [I18n.t('invoices.pdf.invoice_date') + ':',
         (I18n.l(invoice.sent_at) if invoice.sent_at)],
        [I18n.t('invoices.pdf.due_at') + ':',
         (I18n.l(invoice.due_at) if invoice.due_at)],
        [I18n.t('invoices.pdf.creator') + ':',
         (invoice.creator.full_name if invoice.creator)]
      ]
    end
  end
end
