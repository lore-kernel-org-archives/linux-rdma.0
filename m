From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: 281e36cbaf causes FlexBoot iSCSI errors
Date: Fri, 16 Jun 2017 13:41:33 -0600
Message-ID: <CAANLjFpJHvGmVX54_DZm80tbP094UwEWyhPs8KCocg4YzNyq=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

281e36cbaf : iscsi-target: Drop work-around for legacy GlobalSAN initiator

Causes "No response for proposed key "FirstBurstLength"." when the
target is running 4.9.32. We tested both FlexBoot 3.5.109 and 3.5.110.
If we revert 281e36cbaf then FlexBoot 3.5.109 boots fine, but FlexBoot
3.5.110 fails with messages "cmd exceeds last lba 64 (lba 64, sectors
1)".

It seems that FlexBoot has relied upon the workaround that now has been removed.

We have had to revert the patch and downgrade the firmware to get
things working again.

# flint -d /dev/mst/mt4115_pciconf0 q
Image type:          FS3
FW Version:          12.18.1000
FW Release Date:     25.1.2017
Product Version:     rel-12_18_1000
Rom Info:            type=PXE version=3.5.109 devid=4115
Description:         UID                GuidsNumber
Base GUID:           248a0703001e7cc8        4
Base MAC:            0000248a071e7cc8        4
Image VSD:
Device VSD:
PSID:                MT_2150110033

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
