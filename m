From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: Re: [PATCH] osmtest - Add OSM_CDECL to main() declaration
Date: Tue, 13 Oct 2009 00:18:11 +0200
Message-ID: <20091012221811.GO13830@me>
References: <41F5872023464A3C8FD5828F037B4D77@amr.corp.intel.com>
	<20091012214322.GI13830@me>
	<3F6F638B8D880340AB536D29CD4C1E1912C896BB9E@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C896BB9E@orsmsx501.amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Smith, Stan" <stan.smith@intel.com>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 14:58 Mon 12 Oct     , Smith, Stan wrote:
> >
> >>  {
> >>      static osmtest_t osm_test;
> >>      osmtest_opt_t opt = { 0 };
> 
> Sean maintains a separate set of patches applied to IB diags in order to address issues like the x86 requirement for __cdecl on main().
> Since OSM_CDECL was already defined in OFED opensm, it did not seem to be a major concession to prefix main() with it.
> Options:
> 1) utilize OSM_CDECL
> 2) throw an ugly ifdef __WIN__ or ifdef __linux__ around main()
> 3) Create more Windows-only patches required for the Windows implementation of OFED opensm & tools.

Any options for windows compiler about call conventions?

Sasha
