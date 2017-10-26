From: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Mellanox CX5 Not Showing Up In ibv_devices (on some systems)
Date: Thu, 26 Oct 2017 17:32:28 +0000
Message-ID: <DE927C68B458BE418D582EC97927A9287FD167C8@ORSMSX113.amr.corp.intel.com>
References: <DE927C68B458BE418D582EC97927A9287FD16661@ORSMSX113.amr.corp.intel.com>
 <20171026165940.GC5829@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171026165940.GC5829-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, October 26, 2017 10:00 AM
> To: Gruher, Joseph R <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Mellanox CX5 Not Showing Up In ibv_devices (on some systems)
> 
> On Thu, Oct 26, 2017 at 04:49:29PM +0000, Gruher, Joseph R wrote:
> 
> > Hi, I'm having trouble with ibv_devices (and related tools like
> > ibv_devinfo, ib_send_bw, etc) not recognizing my Mellanox CX5 NICs in
> > some systems.  The NICs work fine for TCP/IP traffic, and I think for
> > RDMA traffic as well as I can do NVMeoF discovery and make NVMeoF
> > connections, but they're just not listed in ibv_devices.
> 
> > intel@BigTwin-A:~$ sudo ibv_devices
> > libibverbs: Warning: no userspace device-specific driver found for
> > /sys/class/infiniband_verbs/uverbs0
> 
> Well, that is pretty big clue, you haven't installed the user space support
> library.
> 
> Depending on what os you are using it is either in the libmlx5 or ibverbs-
> providers packages,
> 

I hear what you're saying, but as far as I can tell the relevant packages are installed, and the same packages on both systems?  See below.  Am I missing one I should have?

I do see now that the version are not identical, the working system has newer versions, so perhaps that is a problem...

Working system:

nvmf@nvmfji03:~$ dpkg --list|grep mlx
ii  libmlx5-1                                  1.2.1-1ubuntu2                            amd64        Userspace driver for Mellanox Connect-IB InfiniBand HCAs
ii  libmlx5-dev                                1.2.1-1ubuntu2                            amd64        Development files for the libmlx5 driver

nvmf@nvmfji03:~$ dpkg --list|grep ibverbs
ii  ibverbs-utils                              1.2.1-2ubuntu1                            amd64        Examples for the libibverbs library
ii  libibverbs-dev                             1.2.1-2ubuntu1                            amd64        Development files for the libibverbs library
ii  libibverbs1                                1.2.1-2ubuntu1                            amd64        Library for direct userspace use of RDMA (InfiniBand/iWARP)

nvmf@nvmfji03:~$ sudo ibv_devices
    device                 node GUID
    ------              ----------------
    mlx5_1              248a070300a43add
    mlx5_0              248a070300a43adc

Failing system:

intel@BigTwin-A:~$ dpkg --list|grep mlx
ii  libmlx5-1                            1.0.2-1ubuntu2                             amd64        Userspace driver for Mellanox Connect-IB InfiniBand HCAs
ii  libmlx5-dev                          1.0.2-1ubuntu2                             amd64        Development files for the libmlx5 driver

intel@BigTwin-A:~$ dpkg --list|grep ibverbs
ii  ibverbs-utils                        1.1.8-1.1ubuntu2                           amd64        Examples for the libibverbs library
ii  libibverbs-dev                       1.1.8-1.1ubuntu2                           amd64        Development files for the libibverb  library
ii  libibverbs1                          1.1.8-1.1ubuntu2                           amd64        Library for direct userspace use of RDMA (InfiniBand/iWARP)

intel@BigTwin-A:~$ sudo ibv_devices
libibverbs: Warning: no userspace device-specific driver found for /sys/class/infiniband_verbs/uverbs0
    device                 node GUID
    ------              ----------------

Thanks,
Joe
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
