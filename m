From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v2] [OFED] libibverbs: Support both OFED verbs and ibverbs
Date: Thu, 14 Jul 2011 09:13:09 -0400
Message-ID: <FD32F2C0-80E1-4F66-9613-0BB7A604BB12@cisco.com>
References: <1828884A29C6694DAF28B7E6B8A8237302DD1C@ORSMSX101.amr.corp.intel.com> <201107141613.08992.jackm@dev.mellanox.co.il>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201107141613.08992.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean pinged me last night about XRC in Open MPI last night (note that I am no longer on the linux-rdma list).

Open MPI uses XRC, but in a non-default manner -- the user has to specifically ask for it at run time.


On Jul 14, 2011, at 9:13 AM, Jack Morgenstein wrote:

> Hi Sean,
> 
> I am pleased that you are putting in the effort to enable the existing OFED user base to continue using its
> code without changes to the XRC calls.
> 
> Regarding XRC and MPI, see below.
> 
> On Wednesday 13 July 2011 20:21, Hefty, Sean wrote:
>> I was able to build and run mvapich2 successfully against libibverbs with
>> this patch applied on top of the current XRC patches.  (The XRC patches are
>> still undergoing work.)  I built mvapich2 using the following configure options:
>> 
>> --with-rdma=gen2 CFLAGS=-DOFED_VERBS
>> and
>> --with-rdma=gen2 CFLAGS='-DOFED_VERBS -D_ENABLE_XRC_
>> 
>> It didn't appear that mvapichs ever used XRC
>> 
> You are correct, mvapich does not use XRC.
> openMPI uses XRC, so hopefully you can use openMPI to test out your XRC stuff.
> 
> You can contact Jeff Squyres for details/help.
> 
> In the meantime, I include the following from the ewg list:
> =============================================================
> On 11/08/2010 08:06 PM, Jeff Squyres wrote:
>> Steve pinged me on IM this morning and told me that you want OMPI v1.4.3 for the next OFED release.  I just logged into www.openfabrics.org
>> and apparently the server has changed -- my entire $HOME is empty. 
>> 
>> Where do you want me to put the new OMPI SRPM?  Alternatively, anyone can grab the SRPM from the URL below
>> -- there's nothing special about the SRPM for OpenFabrics that's not already in our community SRPM: 
>> 
>>     http://www.open-mpi.org/software/ompi/v1.4/
>> 
> 
> Hi Jeff,
> The place for the Open MPI on the new server is under:
> /var/www/openfabrics.org/downloads/openmpi/   (http://www.openfabrics.org/downloads/openmpi/)
> 
> I updated Open MPI version there to v1.4.3.
> 
> Regards,
> Vladimir
> ==========================================================
> 
> -Jack


-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
