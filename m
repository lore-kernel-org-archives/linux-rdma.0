From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: dapltest and listening endpoints.
Date: Thu, 27 Feb 2014 11:35:30 -0600
Message-ID: <005301cf33e2$4f61aae0$ee2500a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Arlin, I'm trying to clean up the dapl/iwarp/cxgb4 issues, and I'm
seeing something strange.  Each time I run a transaction test, I see
that listening endpoints are leaked or left around by the dapltest
server.

Q: after a completed test, should the dapltest server process have
destroyed all of its listening endpoints except for the one used to
handle the next test?   Or does it maybe keep them around and reuse
them?

Here's the server's listening endpoints after running dapltest -T S -D
chelsio  -n 62000:

[root@rac1 ~]# cat /sys/kernel/debug/iw_cxgb4/0000\:06\:00.4/eps
ep ffff8800db0ab200 cm_id ffff880188a9e400 state 1 flags 0x0 stid 960
backlog 1024 192.168.170.55:62000

Here are the server's endpoints after running this from the client: 

dapltest -T T -s rac1-priv -D chelsio -n 62000 -i 1000 -t 16 -w 8 -R BE
server SR 8192 client SR 1892 4 server RR 8192 client RR 8192 client SR
100

[root@rac1 ~]# cat /sys/kernel/debug/iw_cxgb4/0000\:06\:00.4/eps
ep ffff8800db0ab200 cm_id ffff880188a9e400 state 1 flags 0x0 stid 960
backlog 1024 192.168.170.55:62000
ep ffff8800c92c8600 cm_id ffff880189669200 state 1 flags 0x0 stid 961
backlog 1024 192.168.170.55:62001
ep ffff8800ca857000 cm_id ffff880189669400 state 1 flags 0x0 stid 962
backlog 1024 192.168.170.55:62009
ep ffff8800ca2eb200 cm_id ffff8800c8335a00 state 1 flags 0x0 stid 963
backlog 1024 192.168.170.55:62033
ep ffff8800c8456200 cm_id ffff8800c92c8400 state 1 flags 0x0 stid 964
backlog 1024 192.168.170.55:62017
ep ffff8800c9c8ae00 cm_id ffff8800c8456000 state 1 flags 0x0 stid 966
backlog 1024 192.168.170.55:62041
ep ffff8800ca631c00 cm_id ffff8800c85ebe00 state 1 flags 0x0 stid 967
backlog 1024 192.168.170.55:62025
ep ffff8800cae09c00 cm_id ffff8800c9d20e00 state 1 flags 0x0 stid 968
backlog 1024 192.168.170.55:62081
ep ffff8800ca133a00 cm_id ffff8800c9c8ac00 state 1 flags 0x0 stid 970
backlog 1024 192.168.170.55:62057
ep ffff8800c9e01800 cm_id ffff8800ca631a00 state 1 flags 0x0 stid 972
backlog 1024 192.168.170.55:62073
ep ffff880189e39600 cm_id ffff8800c98bc800 state 1 flags 0x0 stid 975
backlog 1024 192.168.170.55:62089
ep ffff8801892ef000 cm_id ffff8800cad45200 state 1 flags 0x0 stid 977
backlog 1024 192.168.170.55:62065
ep ffff880189706200 cm_id ffff880189e39400 state 1 flags 0x0 stid 979
backlog 1024 192.168.170.55:62121
ep ffff88018a172c00 cm_id ffff88018a572e00 state 1 flags 0x0 stid 980
backlog 1024 192.168.170.55:62105
ep ffff88018aa2ec00 cm_id ffff88018a974e00 state 1 flags 0x0 stid 982
backlog 1024 192.168.170.55:62113

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
