From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: rdma/cm: revert associating an RDMA device when binding
	to loopback
Date: Tue, 9 Feb 2010 17:01:21 -0500
Message-ID: <4FA7F42E-308A-4A4D-82D8-87794CB8C4DE@cisco.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com><0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com><4B6C498F.3060708@opengridcomputing.com><38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com><4B6D9948.6040007@opengridcomputing.com><B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com><79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com><4B6FFB1B.40905@mellanox.co.il><4B701FE6.60302@opengridcomputing.com><adawrynwtz9.fsf@roland-alpha.cisco.com><421D3D6710E847C5B7CAC00EB73117C4@amr.corp.intel.com><4B717F5D.8020403@opengridcomputing.com>
	<4B718A2C.2030602@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <4B718A2C.2030602-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Open MPI also now checks for 127.0.0.1/8 and skips them.  This behavior will be included in the upcoming Open MPI v1.4.2 (possibly within a few weeks?) and Open MPI v1.5.0.

Two followup questions:

1. Is this now the recommended way to find all the IP interfaces that support RDMA:

- loop over all local IP addresses
- if 127.0.0.1/8, skip
- try to rdma_bind_addr()
- if it succeeds and verbs ptr is != NULL, it's an RDMA device

(I believe Steve Wise proposed adding an API function to just return a list of IP addresses of RDMA devices a while back; it was rejected, which is why either we use the try-to-rdma_bind_addr() approach)

2. Before Sean backed out the localhost behavior, when you rdma_addr_bind(127.0.0.1), what did the id->verbs pointer correspond to?




On Feb 9, 2010, at 11:15 AM, Pradeep Satyanarayana wrote:

> Steve Wise wrote:
> > This patch works.  It also backports cleanly to ofed-1.5.1/RH5.3.
> >
> > Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> > Steve.
> Steve, Was this tested against both iWARP and IB?
> 
> Thanks
> Pradeep
> 
> _______________________________________________
> ewg mailing list
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
> 


-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/
