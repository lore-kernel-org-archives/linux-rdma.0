From: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Subject: Re: git dead?
Date: Thu, 7 Oct 2010 08:56:39 -0700
Message-ID: <4CADEDB7.1030002@nasa.gov>
References: <AANLkTinKZbW2tE5dw7nGuhcQTRq-iFSTkh6N7tfuNowW@mail.gmail.com> <2EFBCAEF10980645BBCFB605689E08E904A5A38EE7@azsmsx506.amr.corp.intel.com> <AANLkTim9DUs79j1G3QZ1yK=VNnN=xHLYUP3MkUiRcuPQ@mail.gmail.com> <4CACFBCF.3030802@nasa.gov> <AANLkTi=eexv+4TqbO4x_fUy_9yzL3A=+RX4-RGWV9B0_@mail.gmail.com> <4CAD05DE.2020605@nasa.gov> <AANLkTi=hpPRnDHvWN0aE8w_kRKAtk9QGWESe-BYM0TUt@mail.gmail.com> <4CAD083D.20303@nasa.gov> <20101007020556.GA19512@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101007020556.GA19512-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Peeyush-+SHkuY4UpUhWk0Htik3J/w@public.gmane.org" <Peeyush-+SHkuY4UpUhWk0Htik3J/w@public.gmane.org>, Anupam Saha <anupam.saha-+SHkuY4UpUhWk0Htik3J/w@public.gmane.org>, Ashok Reddy <ashok.reddy-+SHkuY4UpUhWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 On 10/06/10 19:05, Jason Gunthorpe wrote:
> On Wed, Oct 06, 2010 at 04:37:33PM -0700, Jeff Becker wrote:
>>  On 10/06/10 16:32, Josh England wrote:
>>> Yeah I tried that.  It gives me:
>>> fatal: The remote end hung up unexpectedly
>> You're right.  Onsumaye folks - can you see what's wrong with the git
>> daemon? Thanks.
> Seems fine here:

Yes you're right - I had an extra /git in my URL. Sorry for the SPAM.

-jeff

> wakko{jgg}/tmp#git clone git://git.openfabrics.org/ofed_1_5/linux-2.6.git
> Initialized empty Git repository in /tmp/linux-2.6/.git/
> ^Cmote: Counting objects: 152715   
> wakko{jgg}/tmp#host git.openfabrics.org
> git.openfabrics.org is an alias for openfabrics.org.
> openfabrics.org has address 69.55.231.68
> openfabrics.org mail is handled by 10 lists.openfabrics.org.
> wakko{jgg}/tmp#git version
> git version 1.7.1
>
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
