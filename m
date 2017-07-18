From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Issues with starting srp_daemon userspace for a 4.13 kernel
Date: Tue, 18 Jul 2017 14:07:08 -0400
Message-ID: <b74ff7c3-734b-71ae-6b67-9a8ccf255bf6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello

What changed in 4.13 so SRP will no longer start because QP cannot 
modify state.

Same test bed as always (based on RHEL 7.3)

Linux dhcp40-139.desklab.eng.bos.redhat.com 4.12.0

Works and srp_daemon activates using:

run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000 -ance -i 
mlx5_0 -p 1 1>/root/srp1.log 2>&1 &
run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000 -ance -i 
mlx5_1 -p 1 1>/root/srp2.log 2>&1 &

[  158.020366] scsi host2: SRP.T10:7CFE900300726E4E
[  158.574651] scsi host1: SRP.T10:7CFE900300726E4E

Now Testing 4.13, same back-end target that IS running 4.13

Client now booted into 4.13

Linux dhcp40-139.desklab.eng.bos.redhat.com 4.13.0-rc1+

[root@dhcp40-139 ~]# run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 
-T 10 -t 7000 -ance -i mlx5_0 -p 1
srp_daemon[4573]: failed to modify QP state to RTR
srp_daemon[4573]: failed to modify QP state from RESET to RTS
[root@dhcp40-139 ~]# run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 
-T 10 -t 7000 -ance -i mlx5_1 -p 1
srp_daemon[4616]: failed to modify QP state to RTR
srp_daemon[4616]: failed to modify QP state from RESET to RTS

Before I start a bisect wanted to ask if I needed a new userspace tools 
for changes in 4.13 maybe

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
