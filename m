From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: Deprecating ipath
Date: Fri, 3 Jul 2015 10:18:07 -0700
Message-ID: <CAB=NE6WL_ezUGaAqqmVHtyw28Cw5LZ5Qs6C5sKuEi9j=om_MBA@mail.gmail.com>
References: <32E1700B9017364D9B60AED9960492BC257567C3@fmsmsx120.amr.corp.intel.com>
 <CAB=NE6WTPKUF3EUVk6Z91pd+PYTjLdrLHr0Gn=n9+Z98cVdPWg@mail.gmail.com>
 <20150626165401.GA14699@kroah.com> <D2F193D21ECD8C45917AD3D5B26513300C48DAD5@CRSMSX101.amr.corp.intel.com>
 <20150703153646.GA11227@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150703153646.GA11227@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 3, 2015 at 8:36 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Jul 03, 2015 at 01:25:25PM +0000, Dalessandro, Dennis wrote:
>> > -----Original Message-----
>> > From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>> > owner@vger.kernel.org] On Behalf Of Greg Kroah-Hartman
>> > Sent: Friday, June 26, 2015 12:54 PM
>> > To: Luis R. Rodriguez
>> > Cc: Marciniszyn, Mike; Borislav Petkov; Ingo Molnar; One Thousand Gnomes;
>> > Doug Ledford; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
>> > Subject: Re: Deprecating ipath
>> >
>> > On Fri, Jun 26, 2015 at 09:23:27AM -0700, Luis R. Rodriguez wrote:
>> > > On Fri, Jun 26, 2015 at 9:17 AM, Marciniszyn, Mike
>> > > <mike.marciniszyn@intel.com> wrote:
>> > > > Doug,
>> > > >
>> > > > We have been given the go ahead to start the deprecation process for
>> > thie ipath driver.
>> > >
>> > > That's great! Do you mean removal from Linux?
>> > >
>> > > > What do I need to do to get that done?
>> > >
>> > > Feature removal txt file was removed from the kernel so there is no
>> > > "schedule" per se, not sure what the process these days is for driver
>> > > removal. How about punting it to staging for a release or two and then
>> > > remove it? Not sure if that would be frowned upon or welcomed.
>> >
>> > That is the process for driver removal, so of course it is welcomed :)
>> >
>> > > That would have the cost of moving history through directories but git
>> > > --follow helps with that these days. The gain of moving it to staging
>> > > IMHO would be that if anyone who might care would need to complain
>> > may
>> > > do so for a directory change for 1-2 release may spot this easily and
>> > > the issues would be much less than an immediate removal.
>> >
>> > Yes, that's why we do it this way.
>> >
>> > Mike, feel free to send me a patch for this if you want me to queue it up for
>> > 4.3.  For 4.2 it's too late.
>> >
>> > thanks,
>> >
>> > greg k-h
>> > --
>>
>> Greg, how would you like to consume that patch? There are a number of large
>> files. We can break things up into a series and send through email. We could
>> also post a repo somewhere that you can do a pull from. Something else?
>
> If you use -M to 'git format-patch' when generating a patch, it will
> show that you just moved the files around the directory tree, and the
> patch should be quite small and easy to email and review.
>
> In fact, you should use that as a default for all patches, as it's now a
> standard that normal patch can use to consume, I have this in my
> .gitalias file:
>         [alias]
>                 fp = format-patch -M
>
> and just use 'git fp' all the time.

And if you still want to use default regular commands then you can use:

[diff]
        renamelimit=0

  Luis
