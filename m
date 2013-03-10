From: Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Adding support for Debian packaging
Date: Sun, 10 Mar 2013 08:21:36 -0500
Message-ID: <CABweQmJUF0Y0Evh+-c12j6Yh0zy_o7JLLTehYv6AZ6aAPz0KsA@mail.gmail.com>
References: <1361441897-19486-1-git-send-email-ilyan@mellanox.com>
	<CABweQmK6zBZSeeLShS8MpcFu6oHVvNw6CF_3sWbqe1dGM-BeUg@mail.gmail.com>
	<CAL1RGDVaiOp84E3SfF6nUkNvjrAeUE=32EdmWusmWZSZqRJ_Qw@mail.gmail.com>
	<512DB43C.5060801@dev.mellanox.co.il>
	<CAL1RGDU3pHNNk_jtVWpW6OPyD1BjOxb8NFYcU=ojWxOGXkusug@mail.gmail.com>
	<512E14E7.9020808@dev.mellanox.co.il>
	<CABweQmKPpRvKZE8JoO_rX3OrUN+nB=u1DOUAJfuwXNP_+54neg@mail.gmail.com>
	<CAJZOPZKOpjrzW4+Gyotxhyx+uKhUHDEU6VeM8PbK-GQFN4z3iA@mail.gmail.com>
	<CAL1RGDXoajY0=W7iJUE4m8a5tgDVbmVihV-gGNVho4Y5cT06gQ@mail.gmail.com>
	<513C58F5.8000803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <513C58F5.8000803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Well, there are both debian releases and ubuntu releases, which occur
on different schedules.

If Mellanox is interested in distributing packages for debian/ubuntu,
I'd recommend both building the packaging for them (which is pretty
much identical, for the most part) as well as running at apt
repository that people can point at. This will give you guys the
ability to build binary packages that you can QA for each release (and
distro release) and distribute them pretty easily to customers.
 -nld

On Sun, Mar 10, 2013 at 4:57 AM, Ilya Nelkenbaum
<ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 2/27/2013 11:21 PM, Roland Dreier wrote:
>> On Wed, Feb 27, 2013 at 11:11 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> You can also take a look on the upstream trees for libibverbs and
>>> libmlx4 maintained by Roland which have a debian dir, which you
>>> probably can re-use for the managment libraries and opensm, here are
>>> the gitweb pointers,
>>>
>>> http://git.kernel.org/?p=libs/infiniband/libibverbs.git;a=summary
>>> http://git.kernel.org/?p=libs/infiniband/libmlx4.git;a=summary
>>
>> I happen to maintain the Debian packaging for libibverbs and libmlx4
>> in the same source tree as the upstream source.  However it's actually
>> easier in the case where the Debian packaging maintainer and the
>> upstream maintainer are different just to leave debian/ directory out
>> of the upstream source.  If you're not really that familiar with
>> Debian packaging and Debian policy, it's probably best just to leave
>> the packaging to the Debian project.
>>
>>  - R.
>>
>
> Hi Roland,
>
> As I understand Debian releases happen less often that the updates and bug fixes in management packages,
> and in case of critical bug fix or some important new feature, client that uses
> a specific package and needs the Debian support cannot just use the latest upstream version
> but will have to wait for the Debian release.
>
> So I guess in such cases it might help and it will also leave less work for the Debian maintainer
>
> What do you think?
>
> Ilya
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
