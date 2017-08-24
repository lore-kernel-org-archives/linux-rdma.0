From: Yigal Korman <yigal@plexistor.com>
Subject: Re: Possible rdma-core header conflict
Date: Thu, 24 Aug 2017 14:28:30 +0300
Message-ID: <CACTTzNYiYCg-hYX8WGYpn6Yg4QZ=XqgQcyB-m_9cSd5D+w0juQ@mail.gmail.com>
References: <CACTTzNa3EzABie9=h2X-ONBefyaoWE1+RAT-T+uxJVvVij15Rg@mail.gmail.com>
 <20170821120310.GL1724@mtr-leonro.local> <20170821155729.GC4401@obsidianresearch.com>
 <CACTTzNar-qBRxkeWHL-gt4C9A6yTbY+GbkTT6tWKvJcnpK=J_g@mail.gmail.com>
 <20170822064704.GR1724@mtr-leonro.local> <20170824105007.GH1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <20170824105007.GH1724@mtr-leonro.local>
Sender: linux-kbuild-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, mmarek@suse.com, linux-kbuild@vger.kernel.org, dhowells@redhat.com, Linux RDMA Mailing List <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 24, 2017 at 1:50 PM, Leon Romanovsky <leon@kernel.org> wrote:
> On Tue, Aug 22, 2017 at 09:47:04AM +0300, Leon Romanovsky wrote:
>> On Tue, Aug 22, 2017 at 09:08:56AM +0300, Yigal Korman wrote:
>> > On Mon, Aug 21, 2017 at 6:57 PM, Jason Gunthorpe
>> > <jgunthorpe@obsidianresearch.com> wrote:
>> > > On Mon, Aug 21, 2017 at 03:03:10PM +0300, Leon Romanovsky wrote:
>> > >> On Mon, Aug 21, 2017 at 12:24:14PM +0300, Yigal Korman wrote:
>> > >> > Hi,
>> > >> > Has anyone noticed that installing rdma-core (or older
>> > >> > librdmacm-devel) package and then installing kernel headers manua=
lly
>> > >> > (make headers_install) removes the librdmacm headers?
>> > >> > I actually see it in the make output:
>> > >> >
>> > >> > make INSTALL_HDR_PATH=3D/usr headers_install
>> > >> >   CHK     include/generated/uapi/linux/version.h
>> > >> >   REMOVE  rdma_cma_abi.h rdma_verbs.h rdma_cma.h rsocket.h
>> > >> >
>> > >> > Am I doing something wrong?
>> > >> > Sounds like the kernel rdma headers and librdmacm headers shouldn=
't
>> > >> > sit in the same directory...
>> > >>
>> > >> It looks like this behavior (removal of header files) was from the =
beginning of git era.
>> > >> =E2=9E=9C  linux-rdma git:(rdma-next) =E2=9C=97 git co -b tmp v2.6.=
34.8
>> > >> =E2=9E=9C  linux-rdma git:(tmp) =E2=9C=97 cp ~/src/rdma-core/librdm=
acm/rdma_verbs.h /tmp/h/include/rdma/ && make INSTALL_HDR_PATH=3D/tmp/h hea=
ders_install | grep REMOVE
>> > >>   REMOVE  rdma_verbs.h
>> > >
>> > > The user space files have also been sharing the directory with the
>> > > kernel files since the start.. Not sure why, but I don't think we ca=
n
>> > > change it now.
>> > >
>> > > Maybe someone can patch the kernel to exempt rdma/ from the removal
>> > > process?
>> >
>> > Yeah, that would be a good possible fix for this.
>> > I had a quick look at the kernel headers install scripts and didn't
>> > see any mechanism for this, but I might've missed it.
>>
>> It is in scripts/Makefile.headersinst
>> The change should be in the ...
>>  66 # Work out what needs to be removed
>>  67 oldheaders    :=3D $(patsubst $(installdir)/%,%,$(wildcard $(install=
dir)/*.h))
>>  68 unwanted      :=3D $(filter-out $(all-files),$(oldheaders))
>>
>> And we should filter out very specific headers, because it is a good thi=
ng
>> to remove all other files to ensure that older headers are removed.
>
> Yesterday, I took a look on various distributions in order to understand
> why we didn't see this issue earlier.
>
> Some distros install kernel headers into separate folder and not
> into /usr/include, so rdmacm header files are not overwritten.
>
> And some distros install kernel headers into different from /usr
> directory, prepare all files in advance and copy them to /usr after
> that without deleting the old files.
>
> So, it looks like there is no need to fix anything, because installation
> of header files with "make INSTALL_HDR_PATH=3D/usr headers_install" is an
> easy thing to do for the development but is not right thing from the dist=
ro
> point of view.
>
> If there is distro which deletes rdmacm headers, it should be fixed there=
 and
> not in the kernel.

Thanks Leon!

So for development workflow, I guess that the trivial thing to do is
to make sure to first install the kernel headers and then install
rdmacm headers.

Y

>
> Thanks
>>
>> > I'm adding linux-kbuild mailing list here, maybe someone there can hel=
p?
>> >
>> > Thanks
>> >
>> > >
>> > > Jason
>
>
