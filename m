From: Craig Prescott <prescott-rKMKKiNZRMeVc3sceRu5cw@public.gmane.org>
Subject: SRP automatic target discovery
Date: Wed, 02 Feb 2011 15:27:23 -0500
Message-ID: <4D49BE2B.3000503@hpc.ufl.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi;

I'm having a problem with SRP automatic target discovery.  I am using 
srp_daemon with OFED 1.5.2 on the initiator.  My one target machine with 
several LUNs also uses OFED 1.5.2, and I am using scst 2.0.0.1 and srpt 
2.0.0 on top of that.

On the initiator, I have SRP_LOAD=yes and SRP_DAEMON_ENABLE=yes.  This 
seems to work fine, and after rebooting, I can see the SRP targets on 
the initiator, and srp_daemon running in the background:

[root@hpcoss2 ~]# ps auxww | grep srp
root      6635  0.0  0.0  63840  1176 ?        S    12:04   0:00 
/bin/bash /usr/sbin/srp_daemon.sh
root      6638  0.0  0.0  63836  1164 ?        S    12:04   0:00 
/bin/bash /usr/sbin/run_srp_daemon -e -c -n -i mlx4_1 -p 1 -R 60 -V
root      6647  0.0  0.0  31012   996 ?        SLl  12:04   0:00 
srp_daemon -e -c -n -i mlx4_1 -p 1 -R 60 -V

But if I add an additional target on the same target machine with, say:

[root@hpcoss1 ~]# echo "add 7:0:1:0 3" 
 >/proc/scsi_tgt/groups/Default/devices

the srp_daemon on the initiator never sees the new storage and 
restarting srp_daemon doesn't seem to help.

If I remove the SRP scsi devices, unload the ib_srp module, and reload 
it, I can see the new LUN (and I don't need to restart srp_daemon, 
either).  But I don't think that is how it is supposed to work.

Am I doing something wrong?

Thanks,
Craig Prescott
UF HPC Center



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
