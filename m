From: Federico Vaga <federico.vaga@vaga.pv.it>
Subject: Re: [PATCH v1 02/22] docs: ioctl-number.txt: convert it to ReST format
Date: Wed, 19 Jun 2019 09:32:14 +0200
Message-ID: <1723505.IrfYrSHNLM@pcbe13614>
References: <cover.1560891322.git.mchehab+samsung@kernel.org> <e8f1c925c5d118717eb38455e8f9dacf340cc35e.1560891322.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e8f1c925c5d118717eb38455e8f9dacf340cc35e.1560891322.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Harry Wei <harryxiyou@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tuesday, June 18, 2019 11:05:26 PM CEST Mauro Carvalho Chehab wrote:
> The conversion itself is simple: add a markup for the
> title of this file and add markups for both tables.
> 
> Yet, the big table here with IOCTL numbers is badly formatted:
> on several lines, the "Include File" column has some values that
> are bigger than the reserved space there.
> 
> Also, on several places, a comment was misplaced at the "Include
> File" space.
> 
> So, most of the work here is to actually ensure that each field
> will be properly fixed.
> 
> Also worth to mention that some URLs have the asterisk character
> on it. Well, Sphinx has an issue with asterisks in the middle
> of an string. As this is URL, use the alternate format: %2A.
> 
> As a side effect of this patch, it is now a lot easier to see that
> some reserved ioctl numbers are missing the include files
> where it is supposed to be used.
> 
> PS.: While this is part of a subdir, I opted to convert this
> single file alone, as this file has a potential of conflicts,
> as most subsystem maintainers touch it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  .../{ioctl-number.txt => ioctl-number.rst}    | 588 +++++++++---------
>  Documentation/process/submit-checklist.rst    |   2 +-
>  .../it_IT/process/submit-checklist.rst        |   2 +-
>  .../zh_CN/process/submit-checklist.rst        |   2 +-
>  include/uapi/rdma/rdma_user_ioctl_cmds.h      |   2 +-

Acked-by: Federico Vaga <federico.vaga@vaga.pv.it>

-- 
Federico Vaga
http://www.federicovaga.it/
