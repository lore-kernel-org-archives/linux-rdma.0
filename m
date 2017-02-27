From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC] libibverbs IB device hotplug support
Date: Mon, 27 Feb 2017 18:08:41 +0200
Message-ID: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduction

---------------------------------------------------------------------------=
-----

Hotplug [1] is the method in which new hardware becomes available in the sy=
stem

or is being removed from it. User space applications would like to continue

operation while hardware is being changed in the system, without the need t=
o

restart the process, lose its current state and lose open sessions (at leas=
t on

other available hardware).



The problem

---------------------------------------------------------------------------=
-----

Today the IB device list is returned by ibv_get_device_list() from libibver=
bs.

This IB device list is created by scanning of the /sys/class/infiniband_ver=
bs

[2]. The list is cached and never updated, no matter if there were hardware

changes in the system.



Detection of hotplug events is not part of libibverbs functionality and thu=
s

not part of this RFC. User space applications should monitor respectful cha=
nges

in the system according to its specific logic to detect plugout or plugin o=
f

hardware devices. This can be does by means of: netlink, udev or other inpu=
ts.



Suggested Solution

---------------------------------------------------------------------------=
-----

In order for user space applications to support hotplug of IB device (PlugI=
n

and PlugOut), libibverbs must be able to provide the application access to =
new

ibv_device objects, according to the recent system hardware changes.



Here I suggest to modify the implementation of ibv_get_device_list() so tha=
t

consecutive calls will re-scan the sysfs in the same manner as done today i=
n

order to create a fresh ibv_device list each time. We will remove caching o=
f

devices that support plugout, while keeping the ibv_device cache for device=
s

which do not support plugout.



For this purpose, the ibv_get_device_list() device scanning logic should be

separated from the libibverbs singleton initialization step.

User can call ibv_open_device() while holding this list (see man pages) and

once ibv_free_device_list() is called libibverbs can release the unused

ibv_device objects. Later, on calls to ibv_close_device(), additional

ibv_device object should be released. Currently, on ibv_free_device_list(),

only the array is freed, while the ibv_device objects are never freed.

libibverbs will maintain a ref_count for each verbs_device object. Increase

verbs_device->ref_count for every ibv_get_device_list() or ibv_open_device(=
).

Decrease it for every ibv_free_device_list() or ibv_close_device().

On decrease, if ref_count tested to be zero, libibverbs will call the provi=
der

library to release the 'strcut verbs_device' which it allocated.

Each provider library should provide a function to release the verbs_device

object: 'uninit_device(struct verbs_device* device)'.

In order to prevent resource leak for provider libraries that do not suppor=
t

plugout API, libibverbs will move the relevant ibv_device=E2=80=99s to a ca=
ched device

list which will never be refreshed (like today) and also remove the respect=
ful

provider library (ibv_driver) from the registered driver list. Remove of th=
e

ibv_driver will make sure future scans of the sysfs will not generate

additional copies of the same ibv_device.



Applications Behavior

---------------------------------------------------------------------------=
-----

Applications use different logic to decide which ibv_device is the relevant

device they want to use. And each application has its own detection logic t=
o

track such changes in device availability.

Few examples: librdmacm logic is based on GUID values. Socket acceleration

(libvma) maps an IB device to its corresponding net iface based on netlink =
and

sysfs. DPDK applications lookup the IB device PCI address. And most MPI

implementation want human specified IB device name in command line and will

probably not handle any hotplug (out or in) events.



It is the application's responsibility to check which ibv_device returned f=
rom

ibv_get_device_list() has changed from previous scan and which is of intere=
st.



Verbs can issue an IBV_EVENT_DEVICE_FATAL async event on an open user space

ibv_context for device's which support the ib_device->disassociate_ucontext=
().

This event will indicate to the application that the device is no longer

operational. In addition, user space CQ channel fd=E2=80=99s blocking calls=
 on recv(),

select(), poll() or epoll() will be released with EINTR errno.



Typical user space application will monitor hardware changes and/or call fo=
r

ibv_get_device_list() only from control path dedicated thread, and not from=
 the

fast path threads.



Pitfall

---------------------------------------------------------------------------=
-----

If a legacy user space application did not follow the ibv_get_device_list()

man page definition, and it saved a private copy of an ibv_device pointer a=
nd

used it after releasing the device list (call to ibv_free_device_list()), t=
hen

ibv_open_device() might seg-fault based on this new suggestion.

We can work around this by moving the IB device re-scan logic to a new API

'ibv_refresh_device_list()' so that only new application using this API wil=
l

have correct behavior as needed.



Reference

---------------------------------------------------------------------------=
-----

[1] https://www.kernel.org/doc/pending/hotplug.txt

[2] https://github.com/linux-rdma/rdma-core/blob/master/Documentation/libib=
verbs.md



API changes

---------------------------------------------------------------------------=
-----

Signed-off-by: Alex Rosenbaum <alexr@xxxxxxxxxxxx>

--- a/libibverbs/verbs.h

+++ b/libibverbs/verbs.h

@@ -1336,6 +1336,7 @@ struct verbs_device {

                                struct ibv_context *ctx, int cmd_fd);

        void    (*uninit_context)(struct verbs_device *device,

                                struct ibv_context *ctx);

+       void    (*uninit_device)(struct verbs_device *device);

+       atomic_t         ref_count;

        /* future fields added here */

};
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
