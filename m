From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] debian: Add new mlx5dv_set_context_attr
 symbol
Date: Mon, 11 Sep 2017 19:04:32 +0200
Message-ID: <1505149472.3732.9.camel@profitbricks.com>
References: <20170911112821.2094-1-benjamin.drung@profitbricks.com>
         <20170911112821.2094-3-benjamin.drung@profitbricks.com>
         <20170911160603.GB32117@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911160603.GB32117-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Am Montag, den 11.09.2017, 10:06 -0600 schrieb Jason Gunthorpe:
> On Mon, Sep 11, 2017 at 01:28:21PM +0200, Benjamin Drung wrote:
> > Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> >  debian/ibverbs-providers.symbols | 1 +
> >  1 file changed, 1 insertion(+)
> 
> We CI test debian builds, why didn't the CI break? Can we fix that?

Missing symbols will be added on build time using the full Debian
package version. So the build will not fail, but lintian will complain
about it: symbols-file-contains-current-version-with-debian-revision

I suggest to run lintian after the build and lintian errors should let
the build fail.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
