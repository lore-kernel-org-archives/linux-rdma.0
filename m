From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.0-1 release - MIC support
Date: Fri, 25 Jul 2014 17:56:39 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972E4EE2C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL v2 (2.1.0) is available at  http://www.openfabrics.org/downloads/dapl

MIC support has been added in this release and is provided with the new MCM provider and MPXYD service. MCM requires the Intel(R) MPSS 3.x (YOCTO) release for Linux to be installed on your system. MPSS 3.x for Linux can be downloaded from:  http://software.intel.com/mic-developer

Vlad, please pull into OFED 3.12-1  

md5sum: 43bd0f2a7e72ef283d27f99f935e615a dapl-2.1.0.tar.gz

For v2.1 package install RPM packages as follow:
 dapl-2.1.0-1
 dapl-utils-2.1.0-1
 dapl-devel-2.1.0-1
 dapl-debuginfo-2.1.0-1

Summary of v2.1 changes:

 Release 2.1.0 (OFED 3.12-1)

 build: add missing NEWS file
 update autogen.sh
 add MCM provider and MPXYD service to build
 mpxyd: service startup script and configuration file
 add readme for MCM provider and MPXYD service
 update Copyright dates
 add new MIC RDMA proxy service daemon (MPXYD)
 add new dapl MIC provider (MCM) to support MIC RDMA proxy services
 MCM: new MIC provider and proxy service definitions
 cleanup build warnings
 common: add CQ,QP,MR abstractions for new MIC provider and data proxy service
 openib: cleanup, use inet_ntop for GIDs, remove some logs, destroy pipes on release
 common: new dapls_evd_cqe_to_event call, cqe to event
 common: init ring_buffer, assign hd/tl pos in range
 allow log level changes during device open
 ucm: fix cm rbuf setup, include grh pad on initialization
 ucm: remove duplicate async_event code, use common async event call
 new lightweight open_query/close_query IB extension for fast attribute query
 dtestcm: add more detailed debug during disconnect phase
 cma: long delays when opening cma provider with no IPoIB configured
 common: new debug levels for low system memory, IA stats, and package info
 build: remove library check for mverbs with --enable-fca
 IB extension: segfault in create collective group with non-vector type IA handle"
 build: change configure help to correctly state collective default=none

MIC support overview:

The new MIC service is designed to provide MIC based DAPL Provider clients with higher bandwidth access to IB fabrics when direct IB fabric access is unavailable or constrained.  It includes a DAPL provider (MCM) and a host based proxy data service (MPXYD) for SND/RCV and RDMA write operations. RDMA write with immediate data is the only IB extension supported. RDMA reads and atomics are not supported. The MCM provider maintains the DAT level API semantics, including ordering requirements of data flow. This new service communicates within a server platform over PCI-E bus using Symmetric Communications Interface (SCI) and a MCM specific MIX (MIC exchange) messaging protocol. On the wire, the MCM provider uses a new CM and WR/WC proxy protocol that can run from either a MIC or HOST. With this
  new protocol the MCM endpoint send and receive channels are managed separately for optimal data services based on physical locality of each endpoint (see below).  Refer to mpxyd.conf for tu
 nable proxy service attributes. See /etc/dat.conf for MCM provider device definitions. 
    
The following shows connectivity modes and data paths supported:
    
    HST -> HST to HCA
    MSS -> MIC to HCA same socket
    MXS -> MIC to HCA cross socket
    
    1.   HST->HST:    Host->HCA->fabric->HCA->Host              (direct->direct)
           HST<-HST:    Host <-HCA<-fabric<-HCA<-Host             (direct<-direct)
    
    2.  MSS->MSS:    KNC-> Host ->HCA->fabric->HCA->KNC  (proxy->direct)
          MSS<-MSS:    KNC<-HCA<-fabric<-HCA<- Host <-KNC  (direct<-proxy)
    
    3.  MSX->MSX:    KNC-> Host ->HCA->fabric->HCA-> Host ->KNC  (proxy->proxy)
          MSX<-MSX:    KNC<- Host <-HCA<-fabric<-HCA<- Host <-KNC  (proxy<-proxy)
    
    4.  MSS->MSX:    KNC-> Host ->HCA->fabric->HCA-> Host ->KNC  (proxy->proxy)
          MSS<-MXS:    KNC<-HCA<-fabric<-HCA<- Host <-KNC                  (direct<-proxy)
    
    5.  MSS->HST:    KNC-> Host ->HCA->fabric->HCA-> Host (proxy->direct)
          MSS<-HST:    KNC<-HCA<-fabric<-HCA<- Host                  (direct<-direct)
    
    6.  MSX->HST:    KNC-> Host ->HCA->fabric->HCA-> Host (proxy->direct)
         MSX<-HST:    KNC<- Host <-HCA<-fabric<-HCA<- Host (proxy<-direct)


Regards,

Arlin
