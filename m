From: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: cqe dump errors on target while running nvme-of large block
 read IO
Date: Wed, 26 Apr 2017 17:17:32 +0000
Message-ID: <DE927C68B458BE418D582EC97927A92855072ECF@ORSMSX113.amr.corp.intel.com>
References: <DE927C68B458BE418D582EC97927A9285505C9EA@ORSMSX113.amr.corp.intel.com>
 <47f19583-1882-09d4-ce1c-534b8e59068b@mellanox.com>
 <DE927C68B458BE418D582EC97927A9285505F0C9@ORSMSX113.amr.corp.intel.com>
 <52c550c1-849b-7ea5-ab34-56543cb9069d@mellanox.com>
 <991b26ec-69d3-9e1c-ed3e-0d6e6618e73a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <991b26ec-69d3-9e1c-ed3e-0d6e6618e73a-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org'" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Joseph, are you sure that flow control is correctly configured and working
> reliably?

Folks, I have to apologize here.  Flow control was at one point configured correctly, but we had a power outage in our lab two weeks ago.  We thought the switch had come back up OK, but late week we were double-checking all the ports in use and we found one port had lost some settings and no longer had flow control enabled (it had also reverted from 100Gb to 50Gb for some reason).  After fixing the port settings we ran IO through the weekend and the early part of this week on a variety of workloads.  We don't seem to be able to reproduce the failure after fixing the port settings.  It looks like this one may have been caused by the lost flow control setting on the switch.  Sorry for the confusion!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
