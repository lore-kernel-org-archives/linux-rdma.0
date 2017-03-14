From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: rdma-core packaging and multilib
Date: Tue, 14 Mar 2017 14:02:15 -0400
Message-ID: <bb6b2274-a120-6a16-0025-4c0b1b090029@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have some internal tools that check for multilib-clean packaging, and 
they're unhappy with ibacm:

Report from TEST_MULTILIB:
[BAD] [ibacm] Subpackage ibacm is not multilib-clean for x86_64 vs i686: 
2 files have non-equal 32/64bit content:
   /usr/share/man/man7/ibacm_prov.7.gz
   /etc/rdma/ibacm_opts.cfg

----8<----
ibacm_prov.7.gz on x86_64 vs i686:
...
-2. be installed under a configured directory, eg., /usr/lib64/ibacm;
+2. be installed under a configured directory, eg., /usr/lib/ibacm;
...
----8<----

Similar for ibacm_opts.cfg:

-# provider_lib_path /usr/lib64/ibacm
+# provider_lib_path /usr/lib/ibacm

Not sure what the ideal resolution is for this. I'd rather not put in 
the wrong path for one arch or the other, and I think lib64 isn't used 
universally by all 64-bit distros.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
