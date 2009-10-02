From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ofw] [PATCH] typeof() not supported in Windows WDK compiler
Date: Fri, 2 Oct 2009 09:02:46 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E8E53@orsmsx501.amr.corp.intel.com>
References: <DB05C7E7F5BE4BE585F311B2437350A5@amr.corp.intel.com>
 <2A3759D0AB7F46D59DF8820EFCFAF1F8@amr.corp.intel.com>
 <20091001234701.GD5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001234701.GD5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hello Sasha,
  Please skip the patch titled 'typeof() not supported in Windows WDK compiler' as Jason's fix does the job thus requiring no src code changes.

Thank you Jason.

Stan.


Jason Gunthorpe wrote:
> On Thu, Oct 01, 2009 at 03:59:00PM -0700, Sean Hefty wrote:
>>> diff --git a/opensm/opensm/osm_drop_mgr.c
>>> b/opensm/opensm/osm_drop_mgr.c index 4f98cc9..8fe5129 100644 +++
>>> b/opensm/opensm/osm_drop_mgr.c @@ -209,8 +209,13 @@ static void
>>>     drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
>>> drop_mgr_clean_physp(sm, p_port->p_physp);
>>>
>>>     while (!cl_is_qlist_empty(&p_port->mcm_list)) {
>>> +#ifndef __WIN__
>>>             mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
>>>                                    mcm_port, list_item);
>>> +#else
>>> +           mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
>>> +                                  mcm_port, list_item, (osm_mcm_port_t*) );
>>> +#endif
>>
>> I'd find this more readable if it were #ifdef rather than #ifndef.
>>
>> That said, I've got to believe that there's a better way to handle
>> these changes.  I just don't know what it is.
>
> Hmm
>
> How about
>
> #ifdef __GCC_
> #define cl_item_obj(item_ptr, obj_ptr, item_field) (typeof(obj_ptr)) \
>         ((void *)item_ptr - (unsigned
> long)&((typeof(obj_ptr))0)->item_field) #else
> #define cl_item_obj(item_ptr, obj_ptr, item_field) (typeof(obj_ptr)) \
>   (void *)((uint8_t*)item_ptr - ((uintptr_t)(&(obj_ptr)->item_field) -
>   ((uintptr_t)&(obj_ptr))))
> #endif
>
> And rely on the C implicit cast from void* to an object type, and rely
> on compiles with gcc to do the extra type checking.
>
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
