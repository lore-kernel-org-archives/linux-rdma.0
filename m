From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v2 64/79] docs: ioctl-number.txt: convert it to ReST
 format
Date: Mon, 22 Apr 2019 11:17:25 -0300
Message-ID: <20190422111725.18c06ea2@coco.lan>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
        <16911408d1ac64c0df5ef3ecdae9cf1cc2df58e4.1555938376.git.mchehab+samsung@kernel.org>
        <32310473e6aef679d00c39028adcfcf4c31f47f7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <32310473e6aef679d00c39028adcfcf4c31f47f7.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Federico Vaga <federico.vaga@vaga.pv.it>, Harry Wei <harryxiyou@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Em Mon, 22 Apr 2019 10:05:39 -0400
Doug Ledford <dledford@redhat.com> escreveu:

> On Mon, 2019-04-22 at 10:27 -0300, Mauro Carvalho Chehab wrote:
> > +0x1b  all                                                            InfiniBand Subsystem
> > +                                                                     <http://infiniband.sourceforge.net/>  
> 
> I did not know this link was in there.  That sourceforge site is 15
> years old and totally obsolete/irrelevant at this point.  This patch
> doesn't have the purpose of fixing this up, but now that it's pointed
> out, we'll make a follow up patch to correct this.

Yeah, I suspect that there are lots of broken links over there.

It seems that some people ended by prepending some broken URLs with:

	http://web.archive.org/web/%2A/

In order to use the web archive to get an old copy of such documents.

So, replacing the link with something like:

	http://web.archive.org/web/%2A/http://infiniband.sourceforge.net/

Would allow retrieving pages. It seems that the last version is there
at:

	https://web.archive.org/web/20190212201603/http://infiniband.sourceforge.net/

Yet, if are there any new repository with updated info, it would make sense
to replace it by the new stuff. 

Alternatively, one could import existing docs (if license is compatible
with GPLv2) and add to the Kernel documentation.

Thanks,
Mauro
