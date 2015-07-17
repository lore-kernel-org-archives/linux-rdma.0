From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nes_store_flash_data() bugged?
Date: Fri, 17 Jul 2015 15:02:15 +0300
Message-ID: <CACVxJT9A9_U_qPxf3o_aWiOtbmtAP70PL7XLaoxLBuQbh1E9vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gstreiff-YmnbK6Gf2bHby3iVrkZq2A@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I've been converting nes.c driver and stumbled upon the following bit
of code (below).

What does marked line is supposed to mean?
If it's usual 0[xX] check, then there are a lot of typos.
If it is not and p[0] is, say, 'x', then simple_strtoul() will return 0
because 'x' is not valid start for hex integer.

Can someone describe what the real format of this flash data is?

  Alexey
------------------
static ssize_t nes_store_flash_data(struct device_driver *ddp,
        const char *buf, size_t count)
{
        char *p = (char *)buf;
        u32 val;
        u32 i = 0;
        struct nes_device *nesdev;

        if (p[1] == 'x' || p[1] == 'X' || p[0] == 'x' || p[0] == 'X') {

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

                val = simple_strtoul(p, &p, 16);
                list_for_each_entry(nesdev, &nes_dev_list, list) {
                        if (i == ee_flsh_adapter) {
                                nes_write32(nesdev->regs + NES_FLASH_DATA, val);
                                break;
                        }
                        i++;
                }
        }
        return strnlen(buf, count);
}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
