From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.28 and compat-dapl-1.2.17 release
Date: Tue, 25 May 2010 01:00:52 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C720D109@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
New release for uDAPL v2.0 (2.0.28) and v1.2 (1.2.17) available at:

http://www.openfabrics.org/downloads/dapl

Latest Packages (see ChangeLog for details):

md5sum: 3f914d57312110cc795d37c28d03b26c compat-dapl-1.2.17.tar.gz 
md5sum: d74a5b1817a5413be2603cfd03e944d6 dapl-2.0.28.tar.gz 

Vlad, please pull into OFED 1.5.2 RC1:

For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 

dapl-2.0.28-1 
dapl-utils-2.0.28-1 
dapl-devel-2.0.28-1 
dapl-debuginfo-2.0.28-1 
compat-dapl-1.2.17-1 
compat-dapl-devel-1.2.17-1 

Summary of v2.0 and v1.2 changes: 

Release 2.0.28 fixes (OFED 1.5.2): 

config: add conditional check for new verbs port_attr.link_layer 
dat.conf: update manpage with latest provider information, add examples 
cma, scm: new provider entries for Mellanox RDMA over Ethernet device 
dapltest: server info devicename is not large enough for dapl_name storage 
windows: comp_channel.cpp is included by util.c in the openib_common. 
windows: need to include linux directory to pick up _errno.h 
scm: check for hca object before signaling thread 
scm, cma: fini code can be called multiple times and hang via fork 
scm: add option to use other network devices with environment variable DAPL_SCM_NETDEV 
scm: cr_thread occasionally segv's when disconnecting all-to-all MPI static connections 
scm: SOCKOPT ERR Connection timed out on large clusters 
ucm: UD mode, active side cm object released to soon, the RTU could be lost. 
cma, ucm: cleanup issues with dat_ep_free on a connected EP without disconnecting. 
ucm: increase default UCM retry count for connect reply to 15 
scm: remove modify QP to ERR state during disconnect on UD type QP 
windows: remove static paths from dapltest scripts 
common: EP links to EVD, PZ incorrectly released before provider CM objects freed. 
common: remove unnecessary lmr lkey hashing and duplicate lkey checking 
ibal: output completion code in deciaml & hex as intended 
ucm: set timer during RTU_PENDING state change. 
ucm: fix issues with new EP to CM linking changes 
scm: add EP locking and cm checking to socket cm disconnect 
scm: new cm_ep linking broke UD mode over socket cm 
openib common: add some debug prints to help isolate QP type issues 
common: dapl_event_str function missing 2 IB extended events 
common: dat_ep_connect should not set timer UD endpoints 
ucm: fix error path during accept_usr reply failure 
ibal: add missing windows makefile 
ibal: changes for EP to CM linking and synchronization. 
scm: add support for canceling conn request that times out. 
scm, ucm: consolidate dat event/provider event translation 
common: missed linking changes from atomic to acquire/release 
common: add CM-EP linking to support mutiple CM's and proper protection during destruction 

Release 1.2.17 fixes (OFED 1.5.2): 

config: add conditional check for new verbs port_attr.link_layer 
cma, scm: new provider entries for Mellanox RDMA over Ethernet device for uDAPL v1.2 
cma: memory leak of verbs CQ and completion channels created during dat_ia_open 
cma: memory leak of FD's (pipe) created during dat_evd_create 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
