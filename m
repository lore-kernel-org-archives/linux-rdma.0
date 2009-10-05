From: "Smith, Stan" <stan.smith@intel.com>
Subject: RE: [PATCH] osm_subnet.c
Date: Mon, 5 Oct 2009 09:09:51 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C8783C0D@orsmsx501.amr.corp.intel.com>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8A8F@orsmsx501.amr.corp.intel.com>
	<20091004001316.GK17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <20091004001316.GK17846@me>
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
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> Hi Stan,
>
> On 14:35 Thu 01 Oct     , Smith, Stan wrote:
>>
>> Set function return type to match that of cl_pfn_fmap_cmp_t to align
>> with how the function is invoked.
>>
>> Signed-off-by: stan smith <stan.smith@intel.com>
>>
>> --- a/opensm/opensm/osm_subnet.c        2009-10-01
>> 12:45:52.000000000 -0700 +++ b/opensm/opensm/osm_subnet.c
>> 2009-10-01 14:24:18.000000000 -0700 @@ -397,7 +397,7 @@
>>
>>  /**********************************************************************
>>
>> **********************************************************************/
>> -static long compar_mgids(const void *m1, const void *m2) +static
>> intn_t compar_mgids(const void *m1, const void *m2)
>
> Any disagreement about changing a prototype of this method
> (cl_pfn_fmap_cmp_t) in complib to use standard type (long) instead of
> "homemade" and less clear one ('intn_t')?
>
> Sasha
>
>>  {
>>         return memcmp(m1, m2, sizeof(ib_gid_t));
>>  }

How is the processor architecture 'natural' size intn_t less clear than 'lo=
ng'?
In some worlds sizeof(long) !=3D sizeof(void*).

I would prefer leaving the definition as intn_t as that's the way it has be=
en defined for 'years' (think application code not necessarily OFED) which =
is coded to the intn_t definition.
In the Windows world, cl_fleximap.h is not just an OpenSM utilized file, mo=
re like something that would live in /usr/include.
