From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 00/9] ib/iser: major face lift of the data path code
Date: Mon, 8 Feb 2010 15:15:29 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002081509400.16288@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patch set removes some inefficiencies in the iser data path
through simplification and reducing the amount of code, using less atomic
operations, avoiding TX interrupts, moving to iscsi passthrough mode,
etc. I did my best to build it as a sequence of patches and not as one
big re-write, to ease with maintainance (e.g bisection) and tuning.

changes from V1:
- patch #5: removed white spaces
- patch #8: fixed/adapted the xmit error flow to libiscsi's passthrough mode
- patch #8: got review from Mike Christie

Basically, with Mike's review on the libiscsi related changes being in
place, I am not posting the whole patch series to the open-iscsi mailing
list but rather only this piece.

Roland, I'd be happy to get this in for the 2.6.34 merge window which
is coming quite soon.

Or.

[PATCH V2 01/9] ib/iser: revert commit bba7ebb "avoid recv buffer exhaustion"
[PATCH V2 02/9] ib/iser: new recv buffer posting logic
[PATCH V2 03/9] ib/iser: remove atomic counter for posted recv buffers
[PATCH V2 04/9] ib/iser: use different CQ for send completions
[PATCH V2 05/9] ib/iser: simplify send flow/descriptors
[PATCH V2 06/9] ib/iser: use atomic allocations
[PATCH V2 07/9] ib/iser: remove unnecessary connection checks
[PATCH V2 08/9] ib/iser: move to use libiscsi passthrough mode
[PATCH V2 09/9] ib/iser: remove redundant locking from iser scsi command response flow
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
