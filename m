From: "Smith, Stan" <stan.smith@intel.com>
Subject: RE: [PATCH] osmtest - Add OSM_CDECL to main() declaration
Date: Mon, 12 Oct 2009 15:28:18 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C896BBF9@orsmsx501.amr.corp.intel.com>
References: <41F5872023464A3C8FD5828F037B4D77@amr.corp.intel.com>
	<20091012214322.GI13830@me>
	<3F6F638B8D880340AB536D29CD4C1E1912C896BB9E@orsmsx501.amr.corp.intel.com>
	<20091012221811.GO13830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <20091012221811.GO13830@me>
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
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 14:58 Mon 12 Oct     , Smith, Stan wrote:
>>>
>>>>  {
>>>>      static osmtest_t osm_test;
>>>>      osmtest_opt_t opt =3D { 0 };
>>
>> Sean maintains a separate set of patches applied to IB diags in
>> order to address issues like the x86 requirement for __cdecl on
>> main(). Since OSM_CDECL was already defined in OFED opensm, it did
>> not seem to be a major concession to prefix main() with it.
>> Options:
>> 1) utilize OSM_CDECL
>> 2) throw an ugly ifdef __WIN__ or ifdef __linux__ around main()
>> 3) Create more Windows-only patches required for the Windows
>> implementation of OFED opensm & tools.
>
> Any options for windows compiler about call conventions?
>
> Sasha

Sadly not for x86 architecture on Windows. Both Sean and I have danced arou=
nd this and come up empty.
