From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: failure to get gid with rdma_bind_addr with >= 3.10 kernels
Date: Sun, 10 Nov 2013 13:10:41 +0200
Message-ID: <527F69B1.9070701@mellanox.com>
References: <527F6896.1080802@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------040102000900030209070606"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527F6896.1080802-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--------------040102000900030209070606
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sean,

So somewhere between 3.10 and 3.11 a little bug was introduced in 
ucma/cma that when
you bind to IPv4 address the resulted device address returned from the 
kernel is all zeros.

You can use the attached program to reproduce, just run it and provide 
an IPv4 address of IPoIB NIC

--> with 3.10

$ ./rb 192.168.20.47
event_channel: 0x6093c0
cm_id: 0x602cb0
sgid: fe 80 00 00 00 00 00 00 00 02 c9 03 00 e9 c0 81

--> with 3.12

$ ./rb 192.168.20.17
event_channel: 0x6093c0
cm_id: 0x6034c0
sgid: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

There many commits for the 3.11 AF_IB merge, hope you can dig it out 
quickly..

Or.

linux-2.6]# git log --oneline v3.10.. drivers/infiniband/core/cma.c 
drivers/infiniband/core/ucma.c
7c049d0 Merge tag 'rdma-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
27703bb Merge tag 'PTR_RET-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
24d44a3 RDMA/cma: Add IPv6 support for iWARP
5eb695c RDMA/cma: Only call cma_save_ib_info() for CM REQs
e511d1a RDMA/cma: Fix accessing invalid private data for UD
8fb488d RDMA/cma: Fix gcc warning
8c6ffba PTR_RET is now PTR_ERR_OR_ZERO(): Replace most.
ce117ff RDMA/cma: Export AF_IB statistics
5bc2b7b RDMA/ucma: Allow user space to specify AF_IB when joining multicast
209cf2a RDMA/ucma: Allow user space to pass AF_IB into resolve
eebe4c3 RDMA/ucma: Allow user space to bind to AF_IB
05ad945 RDMA/ucma: Name changes to indicate only IP addresses supported
edaa7a5 RDMA/ucma: Add ability to query GID addresses
cf53936 RDMA/cma: Export cma_get_service_id()
ac53b26 RDMA/ucma: Support querying when IB paths are not reversible
ee7aed4 RDMA/ucma: Support querying for AF_IB addresses
94d0c93 RDMA/cma: Only listen on IB devices when using AF_IB
5c43813 RDMA/cma: Set qkey for AF_IB
e8160e1 RDMA/cma: Expose private data when using AF_IB
fbaa1a6 RDMA/cma: Merge cma_get/save_net_info
01602f1 RDMA/cma: Remove unused SDP related code
496ce3c RDMA/cma: Add support for AF_IB to cma_get_service_id()
f68194c RDMA/cma: Add support for AF_IB to rdma_resolve_route()
f17df3b RDMA/cma: Add support for AF_IB to rdma_resolve_addr()
4ae7152 RDMA/cma: Verify that source and dest sa_family are the same
b0569e4 RDMA/cma: Restrict AF_IB loopback to binding to IB devices only
f475383 RDMA/cma: Add helper functions to return id address information
6a3e362 RDMA/cma: Do not modify sa_family when setting loopback address
680f920 RDMA/cma: Allow user to specify AF_IB when binding
58afdcb RDMA/cma: Update port reservation to support AF_IB
ef56086 IB/addr: Add AF_IB support to ip_addr_size
2e2d190 RDMA/cma: Include AF_IB in loopback and any address checks
c8dea2f9 RDMA/cma: Allow enabling reuseaddr in any state
351638e net: pass info struct via netdevice notifier






--------------040102000900030209070606
Content-Type: text/plain; charset="windows-1255"; name="rb.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="rb.c"

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <errno.h>
#include <string.h>
#include <rdma/rdma_cma.h>

int main( int argc, char **argv ) {
  struct rdma_cm_id *         cm_id         = NULL;
  struct rdma_event_channel * event_channel = NULL;
  int i = 0;
  struct sockaddr_in sa;

  if( argc < 2 ) {
    fprintf( stderr, "Specify interface address\n" );
    exit(1);
  }
 
  if( !inet_aton( argv[1], &sa.sin_addr.s_addr ) ) {
    fprintf( stderr, "Address invalid: %s\n", argv[1] );
    exit(1);
  }

  sa.sin_port   = 0;
  sa.sin_family = AF_INET;

  event_channel = rdma_create_event_channel();
  if( !event_channel ) {
    fprintf( stderr, "rdma_create_event_channel failed" );
    exit(1);
  }
  printf( "event_channel: %p\n", event_channel );

  if( rdma_create_id( event_channel, &cm_id, 0, RDMA_PS_IPOIB ) ) {
    fprintf( stderr, "rdma_create_id failed (%s)", strerror(errno) );
    exit(1);
  }
  printf( "cm_id: %p\n", cm_id );

  if( rdma_bind_addr( cm_id, (void*)&sa ) ) {
    fprintf( stderr, "rdma_bind_addr failed (%s)", strerror(errno) );
    exit(1);
  }

  uint8_t * x  = (uint8_t*)&cm_id->route.addr.addr.ibaddr.sgid;
  size_t    sz = sizeof( cm_id->route.addr.addr.ibaddr.sgid );

  printf( "sgid: " );

  for( i = 0; i < sz; ++i ) {
    printf( "%2.2x ", x[i] );
  }

  printf( "\n" );
  return 0;
}


--------------040102000900030209070606--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
