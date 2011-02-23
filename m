From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: OFA management tree seperation
Date: Wed, 23 Feb 2011 12:12:40 +0200
Message-ID: <20110223101240.GA9811@calypso.voltaire.com>
References: <20110213075550.GB5697@calypso.voltaire.com>
 <20110213225909.GA4506@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110213225909.GA4506-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 15:59 Sun 13 Feb     , Jason Gunthorpe wrote:
> On Sun, Feb 13, 2011 at 09:55:50AM +0200, Alex Netes wrote:
> > 
> > We finished the management tree seperation.
> > From now on, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> takes the responsibility for maitaining libibmad and
> > infiniband-diags. His trees are:
> > 
> >     git://git.openfabrics.org/~iraweiny/libibmad
> >     git://git.openfabrics.org/~iraweiny/infiniband-diags
> > 
> > libibumad, opensm and ibsim trees stays under my responsibility:
> > 
> >     git://git.openfabrics.org/~alexnetes/libibumad
> >     git://git.openfabrics.org/~alexnetes/opensm
> >     git://git.openfabrics.org/~alexnetes/ibsim
> 
> Can you please include the OpenSm 3.2.6 and related branch and tags in
> your repository?
> 

Done. OpenSM 3.2.6 resides on opensm-3.2 branch as before.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
