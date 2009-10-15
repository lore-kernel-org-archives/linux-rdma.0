From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: Re: [PATCH] osmtest - Add OSM_CDECL to main() declaration
Date: Wed, 14 Oct 2009 21:57:36 -0700
Message-ID: <4906481573F74B84AFB1CE0D0EDD326E@amr.corp.intel.com>
References: <41F5872023464A3C8FD5828F037B4D77@amr.corp.intel.com>	<20091012214322.GI13830@me>	<3F6F638B8D880340AB536D29CD4C1E1912C896BB9E@orsmsx501.amr.corp.intel.com>
	<20091012221811.GO13830@me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <20091012221811.GO13830@me>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: 'Sasha Khapyorsky' <sashak@voltaire.com>, "Smith, Stan" <stan.smith@intel.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>> Sean maintains a separate set of patches applied to IB diags in order to
>address issues like the x86 requirement for __cdecl on main().
>> Since OSM_CDECL was already defined in OFED opensm, it did not seem to be a
>major concession to prefix main() with it.
>> Options:
>> 1) utilize OSM_CDECL
>> 2) throw an ugly ifdef __WIN__ or ifdef __linux__ around main()
>> 3) Create more Windows-only patches required for the Windows implementation
>of OFED opensm & tools.
>
>Any options for windows compiler about call conventions?

To clarify, I maintain a single patch to handle this for the signal() callback
handler, not the ib-diags main() functions.

Here's what I use in the sources file for building the diags:

MSC_WARNING_LEVEL = /W3 /WX /wd4007

- Sean
