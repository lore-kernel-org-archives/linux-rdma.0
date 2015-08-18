From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 10:08:04 -0700
Message-ID: <55D36674.60501@infradead.org>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com>
 <20150818161102.GA4040@kroah.com>
 <32E1700B9017364D9B60AED9960492BC25799762@fmsmsx120.amr.corp.intel.com>
 <20150818165026.GA25138@kroah.com>
 <9D026CCE-9F4F-4F87-BA05-AAD6C2C6A417@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9D026CCE-9F4F-4F87-BA05-AAD6C2C6A417-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/18/15 10:00, Doug Ledford wrote:
>=20
>> On Aug 18, 2015, at 9:50 AM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> On Tue, Aug 18, 2015 at 04:29:50PM +0000, Marciniszyn, Mike wrote:
>>>> Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
>>>>
>>>> On Tue, Aug 18, 2015 at 10:15:42AM -0400, Mike Marciniszyn wrote:
>>>>> The move from infiniband to staging requires a temporary PCI
>>>>> dependency to fix 0-day build issues.  The
>>>>> drivers/infiniband/hw/Kconfig gratuitously added it for all drive=
rs.
>>>>>
>>>>> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>> ---
>>>>> drivers/staging/hfi1/Kconfig |    2 +-
>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> Why are these drivers not in drivers/staging/infiniband/ ?  Why do=
 they all
>>>> need their own drivers/staging/ directory?
>>>>
>>>
>>> Greg, what is the path name convention for adding a driver to stagi=
ng
>>> when its eventual destination is part of a subsystem?  Perhaps it
>>> should be drivers/staging/hw/hfi1?
>>
>> As I have no idea what this driver is, or what it is for,
>=20
> It=92s a driver for Intel=92s newest RDMA capable fabric interface.  =
It=92s not InfiniBand, but Intel=92s answer to InfiniBand and will even=
tually live in the drivers/infiniband/hw tree with the other RDMA capab=
le device drivers.


Apparently it also needs to depend on INFINIBAND:

(from today's linux-next)


drivers/built-in.o: In function `ipath_remove_one':
ipath_driver.c:(.text+0x7591cb): undefined reference to `ib_wq'
drivers/built-in.o: In function `handle_e_ibstatuschanged.isra.10':
ipath_intr.c:(.text+0x768e13): undefined reference to `ib_dispatch_even=
t'
ipath_intr.c:(.text+0x768ee7): undefined reference to `ib_dispatch_even=
t'
ipath_intr.c:(.text+0x768f4b): undefined reference to `ib_dispatch_even=
t'
drivers/built-in.o: In function `signal_ib_event':
(.text+0x76af44): undefined reference to `ib_dispatch_event'
drivers/built-in.o: In function `ipath_process_mad':
(.text+0x76e684): undefined reference to `ib_dispatch_event'
drivers/built-in.o:(.text+0x76ee0b): more undefined references to `ib_d=
ispatch_event' follow
drivers/built-in.o: In function `ipath_modify_qp':
(.text+0x770bb1): undefined reference to `ib_modify_qp_is_ok'
drivers/built-in.o: In function `ipath_release_user_pages_on_close':
(.text+0x782900): undefined reference to `ib_wq'
drivers/built-in.o: In function `ipath_register_ib_device':
(.text+0x788fcf): undefined reference to `ib_alloc_device'
drivers/built-in.o: In function `ipath_register_ib_device':
(.text+0x789063): undefined reference to `ib_dealloc_device'
drivers/built-in.o: In function `ipath_register_ib_device':
(.text+0x78971d): undefined reference to `ib_register_device'
drivers/built-in.o: In function `ipath_register_ib_device':
(.text+0x789921): undefined reference to `ib_unregister_device'
drivers/built-in.o: In function `ipath_unregister_ib_device':
(.text+0x7899b2): undefined reference to `ib_unregister_device'
drivers/built-in.o: In function `ipath_unregister_ib_device':
(.text+0x789cc7): undefined reference to `ib_dealloc_device'
drivers/built-in.o: In function `set_link_state':
(.text+0x79aca2): undefined reference to `ib_dispatch_event'
drivers/built-in.o: In function `hfi1_free_devdata':
(.text+0x7b2a54): undefined reference to `ib_dealloc_device'
drivers/built-in.o: In function `remove_one':
init.c:(.text+0x7b2ec0): undefined reference to `ib_wq'
drivers/built-in.o: In function `hfi1_alloc_devdata':
(.text+0x7b2f20): undefined reference to `ib_alloc_device'
drivers/built-in.o: In function `hfi1_alloc_devdata':
(.text+0x7b307b): undefined reference to `ib_dealloc_device'
drivers/built-in.o: In function `init_one':
init.c:(.text+0x7b49af): undefined reference to `ib_wq'
drivers/built-in.o: In function `handle_linkup_change':
(.text+0x7b4da1): undefined reference to `ib_dispatch_event'
drivers/built-in.o: In function `send_handler':
mad.c:(.text+0x7b5f3d): undefined reference to `ib_free_send_mad'
drivers/built-in.o: In function `send_trap.constprop.29':
mad.c:(.text+0x7b76ab): undefined reference to `ib_create_send_mad'
mad.c:(.text+0x7b77d0): undefined reference to `ib_free_send_mad'
mad.c:(.text+0x7b77fe): undefined reference to `ib_post_send_mad'
drivers/built-in.o: In function `subn_set_opa_sma':
mad.c:(.text+0x7bad4f): undefined reference to `ib_dispatch_event'
mad.c:(.text+0x7baf72): undefined reference to `ib_dispatch_event'
mad.c:(.text+0x7bc016): undefined reference to `ib_dispatch_event'
mad.c:(.text+0x7bc062): undefined reference to `ib_dispatch_event'
drivers/built-in.o: In function `hfi1_create_agents':
(.text+0x7beb07): undefined reference to `ib_register_mad_agent'
drivers/built-in.o: In function `hfi1_create_agents':
(.text+0x7beb9d): undefined reference to `ib_unregister_mad_agent'
drivers/built-in.o: In function `hfi1_free_agents':
(.text+0x7bec6a): undefined reference to `ib_unregister_mad_agent'
drivers/built-in.o: In function `hfi1_free_agents':
(.text+0x7bec71): undefined reference to `ib_destroy_ah'
drivers/built-in.o: In function `hfi1_modify_qp':
(.text+0x7c7446): undefined reference to `ib_modify_qp_is_ok'
drivers/built-in.o: In function `hfi1_modify_qp':
(.text+0x7c7c47): undefined reference to `ib_rate_to_mbps'
drivers/built-in.o: In function `hfi1_make_ud_req':
(.text+0x7e9311): undefined reference to `ib_rate_to_mbps'
drivers/built-in.o: In function `hfi1_check_ah':
(.text+0x7f3e55): undefined reference to `ib_rate_to_mbps'
drivers/built-in.o: In function `hfi1_create_qp0_ah':
(.text+0x7f43d4): undefined reference to `ib_create_ah'
drivers/built-in.o: In function `hfi1_register_ib_device':
(.text+0x7f4bbe): undefined reference to `ib_register_device'
drivers/built-in.o: In function `hfi1_register_ib_device':
(.text+0x7f4d0e): undefined reference to `ib_unregister_device'
drivers/built-in.o: In function `hfi1_unregister_ib_device':
(.text+0x7f4d4e): undefined reference to `ib_unregister_device'



--=20
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
