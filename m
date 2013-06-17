From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: config file lost
Date: Mon, 17 Jun 2013 14:44:43 -0400
Message-ID: <51BF591B.4090002@dev.mellanox.co.il>
References: <51BDB769.70107@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51BDB769.70107-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/16/2013 9:02 AM, Or Gerlitz wrote:
> opensm 3.3.15 comes with /etc/rdma/opensm.conf as part of the rpm,
> 3.3.16 doesn't, why?

I'm not 100% sure about the origin of those RPMs but I think the 3.3.15
one is RedHat packaged and the 3.3.16 appears to be PLD packaged and the
processes are a little different. I suspect the 3.3.16 one is packaged
with the spec file in the tree whereas RedHat uses their own spec file.

FWIW it's simple to generate an up to date config file:

opensm -c opensm.conf

-- Hal

> # rpm -ql opensm-3.3.16-1.el6.x86_64
> /etc/init.d/opensmd
> /etc/logrotate.d/opensm
> /etc/opensm
> /usr/sbin/opensm
> /usr/sbin/osmtest
> /usr/sbin/sldd.sh
> /usr/share/doc/opensm-3.3.16
> /usr/share/doc/opensm-3.3.16/AUTHORS
> /usr/share/doc/opensm-3.3.16/COPYING
> /usr/share/doc/opensm-3.3.16/QoS_management_in_OpenSM.txt
> /usr/share/doc/opensm-3.3.16/README
> /usr/share/doc/opensm-3.3.16/opensm_release_notes-3.3.txt
> /usr/share/doc/opensm-3.3.16/performance-manager-HOWTO.txt
> /usr/share/man/man5/torus-2QoS.conf.5.gz
> /usr/share/man/man8/opensm.8.gz
> /usr/share/man/man8/osmtest.8.gz
> /usr/share/man/man8/torus-2QoS.8.gz
> /var/cache/opensm
> 
> 
> #  rpm -ql opensm-3.3.15-1.el6.x86_64
> /etc/logrotate.d/opensm
> /etc/rc.d/init.d/opensm
> /etc/rdma/opensm.conf
> /etc/sysconfig/opensm
> /usr/sbin/opensm
> /usr/sbin/osmtest
> /usr/share/doc/opensm-3.3.15
> /usr/share/doc/opensm-3.3.15/AUTHORS
> /usr/share/doc/opensm-3.3.15/COPYING
> /usr/share/doc/opensm-3.3.15/ChangeLog
> /usr/share/doc/opensm-3.3.15/INSTALL
> /usr/share/doc/opensm-3.3.15/NEWS
> /usr/share/doc/opensm-3.3.15/README
> /usr/share/doc/opensm-3.3.15/doc
> /usr/share/doc/opensm-3.3.15/doc/QoS_management_in_OpenSM.txt
> /usr/share/doc/opensm-3.3.15/doc/opensm-sriov.txt
> /usr/share/doc/opensm-3.3.15/doc/opensm_release_notes-3.3.txt
> /usr/share/doc/opensm-3.3.15/doc/partition-config.txt
> /usr/share/doc/opensm-3.3.15/doc/performance-manager-HOWTO.txt
> /usr/share/man/man5
> /usr/share/man/man5/torus-2QoS.conf.5.gz
> /usr/share/man/man8
> /usr/share/man/man8/opensm.8.gz
> /usr/share/man/man8/osmtest.8.gz
> /usr/share/man/man8/torus-2QoS.8.gz
> /var/cache/opensm
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
