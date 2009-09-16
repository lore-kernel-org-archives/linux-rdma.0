From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Merge process for OFED patches
Date: Wed, 16 Sep 2009 08:05:02 -0700
Message-ID: <60BEFF3FBD4C6047B0F13F205CAFA383038D854F67@azsmsx501.amr.corp.intel.com>
References: <e2e108260909160544r6a1099afvadd3e9b80a84a748@mail.gmail.com>
	 <ada8wgfezrc.fsf@cisco.com>
 <e2e108260909160739g3191b5fo80064b5c081ab989@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260909160739g3191b5fo80064b5c081ab989-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>I would like to contact the author of the fourth patch. But
>unfortunately I could not find any author information in that patch.

Here is the info:

git log kernel_patches/fixes/srp_4_dev_loss_tmo.patch



commit c97ac3a3c509b6fd1fd511e44e81699c21704629
Author: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Tue Dec 9 10:34:38 2008 +0200

    SRP: Fixed the following issue:
    https://bugs.openfabrics.org/show_bug.cgi?id=1395

    Signed-off-by: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 304c1ab9f7256f9673394e5b579c196055804f48
Author: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Nov 27 11:13:03 2008 +0200

    SRP: Fixed the following issues:
    https://bugs.openfabrics.org/show_bug.cgi?id=1377
    https://bugs.openfabrics.org/show_bug.cgi?id=1395

    Signed-off-by: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 245a9d91612a1fd3ada1703dea0bb49af379f457
Author: John Gregor <john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Sep 15 17:49:27 2008 -0700

    Refreshed all "fixes" patches

    Did a "quilt refresh" on all of the patches under kernel_patches/fixes.
    This has several effects:
    1. It regularizes the style of all the patches.
    2. It resets all the line numbers and contexts.
    3. It gets rid of the whitespace problems that required 'patch -l'.
    4. It allows stacked-git to use the patches.

    The flags I used on refresh were:
        --no-timestamps
        --diffstat
        --sort
        --strip-trailing-whitespace

    I've confirmed that the resulting tree is identical (with the exception
    of the trailing whitespace removal).

    Signed-off-by: John Gregor <john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit e79bfe1ad72c06d19a12a3bb9ca856f6509e0109
Author: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Sun Jun 15 15:08:10 2008 +0300

    SRP: Added backport patches for kernels <= 2.6.25.

    Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


Chien

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
