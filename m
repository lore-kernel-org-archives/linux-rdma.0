From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: false checkpatch finding?
Date: Wed, 12 Oct 2016 14:04:11 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2D0F608F@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

<4.8 tree>/scripts/checkpatch.pl -F foo.h
WARNING: Missing a blank line after declarations
#3: FILE: foo.h:3:
+       unsigned long f1;
+       volatile __le64 f2.

WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
#3: FILE: foo.h:3:
+       volatile __le64 f2.

total: 0 errors, 2 warnings, 4 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

foo.h has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Adding a gratuitous blank line after f1 silences the bogus warning.

The volatile warning is ok because this is a hardware written field.

Snip the test file from below.

Mike

<snip foo.h>
struct foo {
	unsigned long f1;
	volatile __le64 f2.
};
</snip foo.h>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
