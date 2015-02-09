From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 00/19] IB/mad: Add support for Intel Omni-Path
 Architecture (OPA) MAD processing.
Date: Mon, 9 Feb 2015 21:20:34 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC21D76@CRSMSX101.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <54D52562.5050408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D52562.5050408-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 2/4/2015 6:29 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > The following patch series modifies the kernel MAD processing
> > (ib_mad/ib_umad) and related interfaces to send and receive Intel
> > Omni-Path Architecture MADs on devices which support them.
> >
> > In addition to supporting some IBTA management classes, OPA devices
> > use MADs with lengths up to 2K.  These "jumbo" MADs increase the
> > performance of management traffic.
> >
> > To distinguish IBTA MADs from OPA MADs a new Base Version is introduced.
> 
> With your recent changes, I don't think that statement above is strictly true any
> longer. While OPA does use a different base version for it's jumbo MADs, aren't
> OPA MADs distinguished from IBTA MADs by the new OPA MAD device
> capability bit ?
> 

True.

However, OPA MADs with a base version of 0x1 are compatible with and therefore can be processed by the same code as IBTA MADs.

If I need to respin the series I will update the comment.

> 
> What performance tests were run in terms of IBTA MADs ?

Sorry for the delay.  As there have been a couple of versions of this series since I ran those tests in December I took the time to re-run these tests.  

OpenSM (sweep time) and infiniband-diag (iblinkinfo and saquery) were timed on my small cluster with no noticeable change in performance.  But this is not the best test as I only have 6 or so nodes on 2 switches.

For example iblinkinfo runs very quickly:

[root@phcppriv12 OPENIB_FF]# time iblinkinfo > /dev/null

real    0m0.072s
user    0m0.002s
sys     0m0.041s


The better test we have at this small scale are a couple of tools (closed source) which send SMA and PMA packets as rapidly as possible.

Those showed no difference in performance.

For example I ran these tools with 3 different kernels 1) "stock roland",  2) the series in question up to the kmalloc patch,  and  final 3) then the full OPA series.

Here is a summary of the results:

                   Roland for-next (ecb7b12)             up to kmalloc patch                   full OPA patch set

SMA            21072                                                21324                                        21381
SMA rcv      17139                                                17329                                        17303

PMA            24159.4                                             24401.2                                     24166.5
PMA rcv      24159.4                                             24401.2                                     24166.5


NOTE: The results shown above are specifically shown without units as I am not allowed to publish performance numbers.  However larger numbers equal better performance.

The numbers are quite repeatable and as you can see are all close to each other from kernel to kernel.
 
The remote node for these tests was running the stock RHEL7 kernel.  All software and hardware was held constant except for the kernel patches in question.
	
Ira

> 
> -- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
