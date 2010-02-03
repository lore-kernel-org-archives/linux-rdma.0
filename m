From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/8] ib/iser: major face lift of the data path code
Date: Wed, 3 Feb 2010 17:30:22 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patch set removes some in efficiencies in the iser data path
through simplification and reducing the amount of code, using less atomic
operations, avoiding TX interrupts, moving to iscsi passthrough mode,
etc. I did my best to build it as a sequence of patches and not as one
big re-write, to allow for better debugging (e.g bisection) and tuning.

Or.

[PATCH 01/9] ib/iser: revert commit bba7ebb "avoid recv buffer exhaustion"
[PATCH 02/9] ib/iser: new recv buffer posting logic
[PATCH 03/9] ib/iser: remove atomic counter for posted recv buffers
[PATCH 04/9] ib/iser: use different CQ for send completions
[PATCH 05/9] ib/iser: simplify send flow/descriptors
[PATCH 06/9] ib/iser: use atomic allocations
[PATCH 07/9] ib/iser: remove unnecessary connection checks
[PATCH 08/9] ib/iser: move to use libiscsi passthrough mode
[PATCH 09/9] ib/iser: remove redundant locking from iser scsi command response flow
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
