From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: git dead?
Date: Wed, 6 Oct 2010 16:32:27 -0700
Message-ID: <AANLkTi=hpPRnDHvWN0aE8w_kRKAtk9QGWESe-BYM0TUt@mail.gmail.com>
References: <AANLkTinKZbW2tE5dw7nGuhcQTRq-iFSTkh6N7tfuNowW@mail.gmail.com>
	<2EFBCAEF10980645BBCFB605689E08E904A5A38EE7@azsmsx506.amr.corp.intel.com>
	<AANLkTim9DUs79j1G3QZ1yK=VNnN=xHLYUP3MkUiRcuPQ@mail.gmail.com>
	<4CACFBCF.3030802@nasa.gov>
	<AANLkTi=eexv+4TqbO4x_fUy_9yzL3A=+RX4-RGWV9B0_@mail.gmail.com>
	<4CAD05DE.2020605@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CAD05DE.2020605-NSQ8wuThN14@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yeah I tried that.  It gives me:
fatal: The remote end hung up unexpectedly

On Wed, Oct 6, 2010 at 4:27 PM, Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>=
 wrote:
> =A0On 10/06/10 16:25, Josh England wrote:
>> On Wed, Oct 6, 2010 at 3:44 PM, Jeff Becker <Jeffrey.C.Becker@nasa.g=
ov> wrote:
>>> You need the project repo, e.g.,
>>> http://git.openfabrics.org/git/ofed_1_5/linux-2.6.git
>>
>> Same problem:
>
> Sorry - instead of http://... use git://...
>
> -jeff
>> $ git clone http://git.openfabrics.org/git/ofed_1_5/linux-2.6.git
>> Initialized empty Git repository in /home/josh/src/tmp/linux-2.6/.gi=
t/
>> warning: remote HEAD refers to nonexistent ref, unable to checkout.
>>
>> -JE
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
