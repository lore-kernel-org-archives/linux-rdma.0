From: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: kernel: rejected =?UTF-8?Q?SRP=5FLOGIN=5FREQ=20because=20creating?=
 =?UTF-8?Q?=20a=20new=20RDMA=20channel=20failed=2E?=
Date: Wed, 18 Apr 2012 12:07:11 +0300
Message-ID: <105692b8ae6e4f11fae2848be32f88d7@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all!
Sometimes after srp initiator tryed to relogin to srpt in mainline 
kernel i get the following error. After that no one can create new 
seesion to srp target

Apr 18 13:04:01 store kernel: Received SRP_LOGIN_REQ with i_port_id 
0x0:0x1e0bffff4c6dd9, t_port_id 0x1e0bffff4c7d38:0x1e0bffff4c7d38 and 
it_iu_len 260 on port 1 (guid=0xfe80000000000000:0x1e0bffff4c7d39)
Apr 18 13:04:01 store kernel: mlx4_core 0000:4b:00.0: command 0x19 
failed: fw status = 0x9
Apr 18 13:04:01 store kernel: rejected SRP_LOGIN_REQ because creating a 
new RDMA channel failed.

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
