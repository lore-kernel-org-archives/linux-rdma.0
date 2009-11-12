From: "Smith, Stan" <stan.smith@intel.com>
Subject: RE: RE: [PATCH] opensm - use C99 transportable data type
	forpointer storage
Date: Thu, 12 Nov 2009 10:21:13 -0800
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912CC483045@orsmsx501.amr.corp.intel.com>
References: <086F8B40ADA84EE7B6398F4761937836@amr.corp.intel.com>
	<3F6F638B8D880340AB536D29CD4C1E1912CC482F85@orsmsx501.amr.corp.intel.com>
	<2ED289D4E09FBD4D92D911E869B97FDD01876DAA@mtlexch01.mtl.com>
	<23D45E5AA67A4CFEB34AB441A9E4E32D@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <23D45E5AA67A4CFEB34AB441A9E4E32D@amr.corp.intel.com>
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
To: "Hefty, Sean" <sean.hefty@intel.com>, 'Leonid Keller' <leonid@mellanox.co.il>, Sasha Khapyorsky <sashak@voltaire.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
>> Did you send it before morning coffee or after ?  :)
>>
>> Maybe, because it seems obvious.
>> All are agree with the elimination of unnecessary #ifndef's.
>> As to me, go ahead, commit it.
>
> It needs to be merged into the mgmt.git tree.
>
>>>>  #include <stdlib.h>
>>>> +#include <inttypes.h>
>>>>
>>>>  #ifdef __cplusplus
>>>>  #  define BEGIN_C_DECLS extern "C" {
>>>> @@ -49,7 +50,7 @@
>>>>  #endif                               /* __cplusplus */
>>>>
>>>>  BEGIN_C_DECLS
>>>> -#define st_ptr_t unsigned long
>>>> +#define st_ptr_t uintptr_t
>
> Does anyone know the reason for st_ptr_t at all?  Why not use
> uintptr_t everywhere and avoid the define?

This is a good question. I avoided the issue due to the fact this patch has=
 been submitted before with no feedback so KIS is the game plan for now.

Once the uintptr_t concept has been accepted, then a 2nd step would be to r=
eplace st_ptr_t with uintptr_t and remove the #define.
