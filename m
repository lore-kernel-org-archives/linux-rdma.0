From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] buildlib: use cmake to find python
Date: Mon, 13 Nov 2017 20:56:58 +0100
Message-ID: <80a3b327-366e-39fc-7e8a-cdc08ec3d927@suse.de>
References: <1923c475-0597-a597-36a5-8a33cccae6ef@suse.de>
 <20171113193139.GN6918@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113193139.GN6918-uk2M96/98Pc@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 13/11/2017 à 20:31, Jason Gunthorpe a écrit :
> On Mon, Nov 13, 2017 at 02:00:15PM +0100, Nicolas Morey-Chaisemartin wrote:
>> Depending on the system, python might not be available as pythomn (but python2, python3, etc.)
>> Use FIND_PACKAGE to get the right executable.
> Looks fine to me.
>
>>    # Compute a relative symlink from VERBS_PROVIDER_DIR to LIBDIR
>> -  execute_process(COMMAND python ${CMAKE_SOURCE_DIR}/buildlib/relpath
>> +  execute_process(COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/buildlib/relpath
> I'm assuming this little script works with python3 ?
>
> cbuild won't though..
>

We can work on that later.
cbuild is mostly used for testing so as long as the basic tests are not run directly on TW we should be fine.
And when the time comes, we'll find a work around for TW too.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
