From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH-v3] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Sun, 6 Nov 2011 18:57:47 +0100
Message-ID: <CAO+b5-qJ7OnrQY_EHf4xp=sYuQu_yrJrds7RCBORF9nve57Ziw@mail.gmail.com>
References: <1320251604-32531-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320251604-32531-1-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 2, 2011 at 5:33 PM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> This v3 patch adds the kernel module ib_srpt SCSI RDMA Protocol (SRP) target

Hi Nick,

Sorry that it took so long before I noticed, but checkpatch complains
about the code present on the for-next-merge branch. Can you have a
look at this ?

Thanks,

Bart.

$ git diff lio/for-next-merge^..lio/for-next-merge |
scripts/checkpatch.pl -nosignoff -ignore=LONG_LINE -

ERROR: spaces required around that ':' (ctx:VxW)
#4023: FILE: drivers/infiniband/ulp/srpt/ib_srpt.c:3824:
+	return snprintf(page, PAGE_SIZE, "%d\n", (sport->enabled) ? 1: 0);
 	                                                             ^

ERROR: code indent should use tabs where possible
#4033: FILE: drivers/infiniband/ulp/srpt/ib_srpt.c:3834:
+        int ret;$

WARNING: please, no spaces at the start of a line
#4033: FILE: drivers/infiniband/ulp/srpt/ib_srpt.c:3834:
+        int ret;$

WARNING: please, no space before tabs
#4511: FILE: drivers/infiniband/ulp/srpt/ib_srpt.h:225:
+ * ^I^I the already initiated transfers have finished.$

total: 2 errors, 2 warnings, 4690 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

NOTE: Ignored message types: LONG_LINE

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
