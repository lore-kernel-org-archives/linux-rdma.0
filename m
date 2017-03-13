From: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Subject: no QFSP detection with HFI card
Date: Mon, 13 Mar 2017 12:51:16 +0100
Message-ID: <20170313125116.4cab1f75ba4d0dd0fe96e0df@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm tyring to connect a HFI card to an Omni-Path Edge Switch 100. The
switch detects the QSFP just fine:

Cable05  OEM         Copper     3 meter   20.87  ???  MCP1600-E003-C    6   M9AL0003          Valid

But on the host side, I only get:

[   53.060613] hfi1 0000:01:00.0: hfi1_0: wait_for_qsfp_init: No IntN detected, reset complete
[   53.082820] hfi1 0000:01:00.0: hfi1_0: i2c_bus_write: bus 1, i2c slave 0x50, offset 0x7f, len 0x1; write failed, ret -6
[   53.114661] hfi1 0000:01:00.0: hfi1_0: port 1: QSFP chain 1 can't write QSFP_PAGE_SELECT_BYTE: -6
[   53.137353] hfi1 0000:01:00.0: hfi1_0: QSFP not responding, waiting and retrying 0

Any hint why the card doesn't find the plugged in QSFPs ?

Thomas.

-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
