From: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: =?UTF-8?Q?ib=5Fsrpt=20and=20mellanox=20mthca=20device?=
Date: Tue, 10 Apr 2012 17:52:37 +0300
Message-ID: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all!

I'm  trying to use ib_srpt from mainline kernel (3.3.x and 3.4-rcX)
But right after loading ib_srpt i always get error in dmesg


srpt_add_one(mthca0) failed.

so ib_srpt cannot be used as target

-- 
Best Regards,
Alexey 'Alexxy' Shvetsov
Petersburg Nuclear Physics Institute, Russia
Department of Molecular and Radiation Biophysics
Gentoo Team Ru
Gentoo Linux Dev
mailto:alexxyum-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
mailto:alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org
mailto:alexxy-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
