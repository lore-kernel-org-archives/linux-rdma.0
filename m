From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/5] travis: Add RedHat and SuSE rpmbuild
 support
Date: Thu, 2 Nov 2017 18:34:08 +0100
Message-ID: <8a65f42d-01d4-6c4a-1bed-b1989cdb9e70@suse.de>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-4-leon@kernel.org> <20171102173123.GQ18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102173123.GQ18874-uk2M96/98Pc@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 02/11/2017 à 18:31, Jason Gunthorpe a écrit :
> On Thu, Nov 02, 2017 at 06:55:54PM +0200, Leon Romanovsky wrote:
>> From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Provide a new script for testing rpmbuild under RedHat and SuSE
>> environments which validates both of the suse/rdma-core.spec and
>> redhat/rdma-core.spec specfiles.
>>
>> The script performs the RPM package build test by utilizing the existing
>> cbuild tool.
> This breaks cbuild pkg travis - we should not attempt to build using
> docker when run outside travis:
I'm guessing you meant *in*side travis ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
