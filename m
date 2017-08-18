From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] i40iw: Simplify code
Date: Fri, 18 Aug 2017 12:03:42 -0400
Message-ID: <1503072222.2598.17.camel@redhat.com>
References: <20170716110923.14907-1-christophe.jaillet@wanadoo.fr>
         <20170717193151.GB16652@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170717193151.GB16652@ssaleem-MOBL4.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: faisal.latif@intel.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-17 at 14:31 -0500, Shiraz Saleem wrote:
> On Sun, Jul 16, 2017 at 01:09:23PM +0200, Christophe JAILLET wrote:
> > Axe a few lines of code and re-use existing error handling path to
> > avoid
> > code duplication.
> > 
> 
> Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
