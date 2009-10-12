From: "Smith, Stan" <stan.smith@intel.com>
Subject: RE: [PATCH] osmtest - code cleanup
Date: Mon, 12 Oct 2009 14:49:17 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C896BB77@orsmsx501.amr.corp.intel.com>
References: <4BFF1A3398A74B2AABB948EF2843BF68@amr.corp.intel.com>
	<20091012214054.GH13830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <20091012214054.GH13830@me>
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
> On 11:57 Mon 12 Oct     , Stan C. Smith wrote:
>>
>> Remove unused ifdef __WIN__ & redundant include.
>>
>> Signed-off-by: stan smith <stan.smith@intel.com>
>
> Applied. Thanks. The question is below.
>
>>
>> diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
>> index c6ec955..82a814e 100644 --- a/opensm/osmtest/osmtest.c
>> +++ b/opensm/osmtest/osmtest.c
>> @@ -43,19 +43,13 @@
>>   *
>>   */
>>
>> -#ifdef __WIN__
>> -#pragma warning(disable : 4996)
>> -#endif
>> -
>>  #include <stdio.h>
>>  #include <stdlib.h>
>>  #include <string.h>
>> -#ifdef __WIN__
>> -#include <complib/cl_timer.h>
>> -#else
>> +#ifndef __WIN__
>>  #include <strings.h>
>> -#include <sys/time.h>
>>  #endif
>
> I suppose that windows should have string.h, right? Assuming so could
> we remove '#ifndef __WIN__' completely here?

Yes - I missed this in the linux env. According to the strings.h file, if s=
tring.h is included prior, then strings.h is a nop. Seems the include of st=
rings.h could be removed along with the ifndef __WIN__.
Good catch.

How do you feel about replacing ifndef __WIN__ with ifdef __linux__ in othe=
r situations?


>
> Sasha
>
>> +#include <sys/time.h>
>>  #include <complib/cl_debug.h>
>>  #include "osmtest.h"
