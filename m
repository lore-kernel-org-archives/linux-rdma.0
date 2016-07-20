From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Wed, 20 Jul 2016 14:56:53 +0300
Message-ID: <0fc727fd-bc35-b2bd-f4a7-04efd937d4c3@mellanox.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-6-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1607192021500.5828@east.gentwo.org>
 <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com>
 <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607200448370.12616-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/07/2016 13:03, Christoph Lameter wrote:
> On Wed, 20 Jul 2016, Matan Barak wrote:
>
>>>> +struct ib_uverbs_ioctl_hdr {
>>>> +	__u16 length;
>>>> +	__u16 flags;
>>>> +	__u16 object_type;
>>>> +	__u16 driver_id;
>>>
>>> driver id??? I would have expected that the driver to be used is
>>> already selected through the file handle as passed to the ioctl.
>>>
>>
>> If I recall, Jason proposed that. I think the main reason here is fo=
r strace
>> and debugging. Since the ABI is now driver specific, this helps you =
parse the
>> structs via strace.
>
> You specify the driver_id in the ioctl data structure. The driver in =
an
> ioctl is specified by the descriptor. strace etc would have an easier=
 time
> if we would follow the standard conventions for devices and not add
> another device_id somewhere.
>

If you use only one file (ie rdma_uapi), how will strace know which=20
internal RDMA device is used?
It'll need to same some bits for the entire session to figure that out.

>> This is actually an ongoing discussion we have in the OFVWG. The ben=
efit of
>> unifying rdma-cm and uverbs is that sharing objects (and opening a d=
evice
>> through rdma-cm and pass it to user-space) becomes easier. That mean=
s that
>> security should be handled via selinux.
>
> Why would there be an issue of sharing data between multiple descript=
ors?
> Data could be a subsystem specific state and not device specific if y=
ou
> want to share.
>

Currently uverbs and rdma-cm IDRs are separated. If we would like to=20
introduce a semantics where rdma-cm opens the device (and maybe even=20
access the device's objects) it needs to somehow share ids with the=20
ib_dev context.
So do you suggest that rdma-cm will get a fd and open the required=20
device on this fd while returning a handle bounded to this fd (you stil=
l=20
need to bind the fd to its objects due to security reasons).

>>> I guess we have a good reason for doing so? If so then please docum=
ent
>>> that somewhere. Or did I not see that?
>> The current v2 approach only adds the driver_id for information and =
strace
>> only. I would really like to hear your insights about using a single=
 file
>> (rdma_uapi) vs multiple files as we have today.
>
> Why do you need that information a second time if the descriptor alre=
ady
> provides the device information?
>
> The simple approach would be to have either /dev or /sysfs based
> descriptors that can be opened and then used for ioctls. F.e. open
>
> /sys/class/infiniband/mlx5_0/desc or
>
> /sys/class/infiniband/mlx5_0/ports/1/desc
>
> or create a new hierachy using udev/systemd
>
> f.e. /dev/rdma/mlx5_0
>
> and then run ioctls on that file to configure the device. That is ver=
y
> similar to the traditional use of ioctls. Security for each device ca=
n be
> controlled separately without inspecting the data being passed (which
> would require modifications to the security code). strace and
> other tools would just natively know that the descriptor refers to a =
device.
>
> Additional system calls would allow a straightforward war to control
> passing the descriptor on exec and other fuunky things (see manpage
> for fcntl f.e.). The usual machinery for device descriptor control an=
d
> management would come in almost for free.
>
>

That's exactly where we stand right now. There are some supporters for=20
unifying all devices to one file. Even if you want to unify rdma-cm to=20
the same fd and open the device through it, strace can't know which=20
physical device is used.

If we keep file per device as you described, we don't need this field.

> IOCTL(2)                                            Linux Programmer'=
s
> Manual                                            IOCTL(2)
>
> NAME
>        ioctl - control device
>
> SYNOPSIS
>        #include <sys/ioctl.h>
>
>        int ioctl(int d, int request, ...);
>
> DESCRIPTION
>        The ioctl() function manipulates the underlying device paramet=
ers
> of special files.  In particular, many operating charac=E2=80=90
>        teristics of character special files (e.g., terminals) may be
> controlled with ioctl() requests.  The argument d must be an
>        open file descriptor.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
