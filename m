From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/qib: Add new qib driver for QLogic PCIe InfiniBand
 adapters
Date: Wed, 22 Nov 2017 12:32:32 +0300
Message-ID: <20171122093054.5ys5ur7chetnz7it@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Ralph Campbell,

The patch f931551bafe1: "IB/qib: Add new qib driver for QLogic PCIe
InfiniBand adapters" from May 23, 2010, leads to the following static
checker warning:

	drivers/infiniband/hw/qib/qib_iba7322.c:5700 gpio_7322_mod()
	warn: was expecting a 64 bit value instead of '~mask'

drivers/infiniband/hw/qib/qib_iba7322.c
  5688  static int gpio_7322_mod(struct qib_devdata *dd, u32 out, u32 dir, u32 mask)
  5689  {
  5690          u64 read_val, new_out;
  5691          unsigned long flags;
  5692  
  5693          if (mask) {
  5694                  /* some bits being written, lock access to GPIO */
  5695                  dir &= mask;
  5696                  out &= mask;
  5697                  spin_lock_irqsave(&dd->cspec->gpio_lock, flags);
  5698                  dd->cspec->extctrl &= ~((u64)mask << SYM_LSB(EXTCtrl, GPIOOe));
  5699                  dd->cspec->extctrl |= ((u64) dir << SYM_LSB(EXTCtrl, GPIOOe));
  5700                  new_out = (dd->cspec->gpio_out & ~mask) | out;
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We never use the high 32 bits of ->gpio_out so it could probably be
declared as a u32 the same as "out".

  5701  
  5702                  qib_write_kreg(dd, kr_extctrl, dd->cspec->extctrl);
  5703                  qib_write_kreg(dd, kr_gpio_out, new_out);
  5704                  dd->cspec->gpio_out = new_out;
  5705                  spin_unlock_irqrestore(&dd->cspec->gpio_lock, flags);
  5706          }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
