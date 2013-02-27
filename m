From: Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Adding support for Debian packaging
Date: Wed, 27 Feb 2013 09:47:59 -0600
Message-ID: <CABweQmKPpRvKZE8JoO_rX3OrUN+nB=u1DOUAJfuwXNP_+54neg@mail.gmail.com>
References: <1361441897-19486-1-git-send-email-ilyan@mellanox.com>
	<CABweQmK6zBZSeeLShS8MpcFu6oHVvNw6CF_3sWbqe1dGM-BeUg@mail.gmail.com>
	<CAL1RGDVaiOp84E3SfF6nUkNvjrAeUE=32EdmWusmWZSZqRJ_Qw@mail.gmail.com>
	<512DB43C.5060801@dev.mellanox.co.il>
	<CAL1RGDU3pHNNk_jtVWpW6OPyD1BjOxb8NFYcU=ojWxOGXkusug@mail.gmail.com>
	<512E14E7.9020808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512E14E7.9020808-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ilya. The easiest way to see packaging for a library (from an
upstream apt source) is to run
# This downloads the original source, debian specific patches, and a
package description file
$ apt-get source <pkgname>
# this unpacks all of the files
$ dpkg-source -x <pkgname>*.dsc

This produces a source directory with all of the packaging patches
applied. There may be additional patches carried by the package in the
debian directory with other packaging stuff.
 -nld


On Wed, Feb 27, 2013 at 8:15 AM, Ilya Nelkenbaum
<ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 2/27/2013 9:27 AM, Roland Dreier wrote:
>> On Tue, Feb 26, 2013 at 11:22 PM, Ilya Nelkenbaum
>> <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>> Does the libibumad that is installed in Debian synchronized with the upstream version?
>>
>> I'm not sure what you're asking.  At appropriate times, new upstream
>> versions of software are added to various releases of the Debian
>> distribution, but this is a (semi-) manual process.
>>
>>   - R.
>>
> Hi Roland,
> One more question:
>
> In order to support debian a "debian" directory has to be present in a package dir
> How it happens? and where I can see an example
>
> Thanks,
> Ilya
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
