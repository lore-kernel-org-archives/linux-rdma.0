From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: OFED 3.5 srpt and scst documentation
Date: Tue, 5 Feb 2013 21:31:52 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D58E54E@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Elken, Tom" <tom.elken-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Tziporet Koren (tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It appears that the srpt in the 3.5 kernel and OFED 3.5 now counts on the lio target that is part of the kernel.

The documentation in readme_and_howto/SRPT_README.txt would seem no longer appropriate.

Also the scst and the patches are probably obsolete at this point.

Has someone developed an equivalent howto for the new SCSI target subsystem?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
