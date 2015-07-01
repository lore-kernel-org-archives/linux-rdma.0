From: Joseph Salisbury <joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH][v3.19.y-ckt] IB/ipoib: change init sequence ordering
Date: Wed, 01 Jul 2015 13:27:30 -0400
Message-ID: <55942302.10602@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kamal Mostafa <kamal.mostafa-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

Please consider including upstream commits
be7aa663fc1d9156798f5af3c60e6df45e1fe5de and
e135106fac9525352feb8e49077c8f46c3eaf288 in the next v3.19.y-ckt
release.  They were included mainline as of v4.1-rc1.  These commits
have been tested and confirmed to resolve
http://bugs.launchpad.net/bugs/1467912 .


commit be7aa663fc1d9156798f5af3c60e6df45e1fe5de
Author: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Sat Feb 21 19:27:00 2015 -0500

    IB/ipoib: change init sequence ordering

commit e135106fac9525352feb8e49077c8f46c3eaf288
Author: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Sat Feb 21 19:26:59 2015 -0500

    IB/ipoib: factor out ah flushing

The bug reporter states this bug is only happening with the 3.19 kernel,
these commits may not be needed in other stable kernels.



Sincerely,

Joseph Salisbury


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
