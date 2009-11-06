From: "Smith, Stan" <stan.smith@intel.com>
Subject: RE: [PATCH 1/2] contain pthreads defs with ifdef
	HAVE_LIBPTHREAD
Date: Fri, 6 Nov 2009 09:07:58 -0800
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C8E83568@orsmsx501.amr.corp.intel.com>
References: <F9EFFFF3BD1D442AB6AA993FD6F0B5D8@amr.corp.intel.com>
	<3F6F638B8D880340AB536D29CD4C1E1912C8E0D221@orsmsx501.amr.corp.intel.com>
	<20091106165623.GD7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <20091106165623.GD7192@me>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: Sasha Khapyorsky <sashak@voltaire.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 09:07 Thu 05 Nov     , Smith, Stan wrote:
>>
>> The use of ifdef HAVE_LIBPTHREAD was based on existing
>> HAVE_LIBPTHREAD usage in opensm/include/opensm/osm_stats.h @ line
>> 97.
>
> Right, but it was used due to differences in the functionality between
> cl_event_t and pthread stuff. I would be happy to remove those
> #ifdef's upon such differences elimination.
>
>> If the community prefers the use of macros then these two patches
>> can be skipped.
>
> I think that macros are nicer.
>
> Sasha

OK, will proceed with macros. Skip previously submitted patch set.
I will submit patches to remove relevant HAVE_LIBPTHREAD as not all can/sho=
uld be removed.
