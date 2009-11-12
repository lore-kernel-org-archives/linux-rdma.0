From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ofw] RE: [PATCH] opensm - use C99 transportable data type forpointer storage
Date: Thu, 12 Nov 2009 10:13:59 -0800
Message-ID: <23D45E5AA67A4CFEB34AB441A9E4E32D@amr.corp.intel.com>
References: <086F8B40ADA84EE7B6398F4761937836@amr.corp.intel.com> <3F6F638B8D880340AB536D29CD4C1E1912CC482F85@orsmsx501.amr.corp.intel.com> <2ED289D4E09FBD4D92D911E869B97FDD01876DAA@mtlexch01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD01876DAA-ia22CT07NJfiMCgWhms8HQC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leonid Keller' <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Did you send it before morning coffee or after ?  :)
>
>Maybe, because it seems obvious.
>All are agree with the elimination of unnecessary #ifndef's.
>As to me, go ahead, commit it.

It needs to be merged into the mgmt.git tree.

>> >  #include <stdlib.h>
>> > +#include <inttypes.h>
>> >
>> >  #ifdef __cplusplus
>> >  #  define BEGIN_C_DECLS extern "C" {
>> > @@ -49,7 +50,7 @@
>> >  #endif                               /* __cplusplus */
>> >
>> >  BEGIN_C_DECLS
>> > -#define st_ptr_t unsigned long
>> > +#define st_ptr_t uintptr_t

Does anyone know the reason for st_ptr_t at all?  Why not use uintptr_t
everywhere and avoid the define?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
