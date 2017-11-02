From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] cbuild: Properly create tarball for SuSE
Date: Thu, 2 Nov 2017 18:32:44 +0100
Message-ID: <aaf13d67-848b-d472-ee3a-e8cb5b41bcbc@suse.de>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-3-leon@kernel.org> <20171102171738.GP18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102171738.GP18874-uk2M96/98Pc@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Same here. Cannot reproduce the original issue...

Le 02/11/2017 à 18:17, Jason Gunthorpe a écrit :
> On Thu, Nov 02, 2017 at 06:55:53PM +0200, Leon Romanovsky wrote:
>> From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> The tarball was not created at the expected path by SUSE scripts,
>> causing rpmbuild to fail with the following error:
>> error: File /usr/src/packages/SOURCES/rdma-core-16.tar.gz: No such file or directory
>>
>> This patch fixes the issue by adding ".rpmmacros" file to root's home
>> folder and sets "%_topdir" to the path where we place the source tarball.
> Alaa,
>
> I'm not certain what this patch is about, I don't see these errors
> here:
>
> $ buildlib/cbuild pkg opensuse-42.2 
> Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.JSkP2f
> + umask 022
> + cd /home/jgg/rpmbuild/BUILD
> + cd /home/jgg/rpmbuild/BUILD
> + rm -rf rdma-core-16
> + /usr/bin/gzip -dc /home/jgg/rpmbuild/SOURCES/rdma-core-16.tar.gz
> + /bin/tar -xf -
> + STATUS=0
> + '[' 0 -ne 0 ']'
> + cd rdma-core-16
> + /usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .
> + exit 0
> Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.rzpkKs
> + umask 022
> + cd /home/jgg/rpmbuild/BUILD
> + /usr/bin/rm -rf /home/jgg/rpmbuild/BUILDROOT/rdma-core-16-0.x86_64
> ++ dirname /home/jgg/rpmbuild/BUILDROOT/rdma-core-16-0.x86_64
> + /usr/bin/mkdir -p /home/jgg/rpmbuild/BUILDROOT
> + /usr/bin/mkdir /home/jgg/rpmbuild/BUILDROOT/rdma-core-16-0.x86_64
> + cd rdma-core-16
>
> How can you be getting such a significantly different result?
>
> Are you running cbuild as root or something? What is the docker
> command the script uses?
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
