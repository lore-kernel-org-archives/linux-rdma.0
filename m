From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] libocrdma: Move ocrdma's list
 implementation into common directory
Date: Tue, 27 Sep 2016 19:14:09 +0300
Message-ID: <ff764b75-19af-340b-7228-328462c524ae@dev.mellanox.co.il>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
 <1474786207-2149-5-git-send-email-leon@kernel.org>
 <20160925144121.GA12246@infradead.org> <20160925161315.GD4088@leon.nu>
 <20160925162203.GA32434@infradead.org>
 <20160926174057.GD22965@obsidianresearch.com>
 <20160926221440.GA5878@infradead.org>
 <20160926222319.GA2358@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160926222319.GA2358-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/27/2016 1:23 AM, Jason Gunthorpe wrote:
> On Mon, Sep 26, 2016 at 03:14:40PM -0700, Christoph Hellwig wrote:
>> On Mon, Sep 26, 2016 at 11:40:57AM -0600, Jason Gunthorpe wrote:
>>> Copyright isn't a patent,
>>
>> I know very well, thanks..
>
> Right, mainly for others..
>
>>> assuming freebsd didn't copy any code and
>>> just implemented the same API independently (eg it is an Independent
>>> Creation) they should be OK from a copyright perspective.
>>
>> That's a big IF, as I'm honestly not sure it is.  I don't want to blame
>> anywone because I really don't know but if I had to decided to use it
>> or not I would error on the safe side.
>
> Sounds reasonable.
>
>>> As should be
>>> Rusty's version in CCAN.
>>
>> That's a much safer choice.  It's a lightly different API, though.
>
> Leon? Does this seem doable to you?

Hi Jason,

Leon is out of office for a week, I can take it from here and come to 
the list in coming days with a new candidate series based on previous notes.

Few notes to sync on:
1) Looking at ocrdma_list.h it extends the list default functionality to 
use an internal mutex, see list_lock & list_unlock calls. This is not a 
standard usage of a list. It may require some logic outside list.h to 
replace the usage without introducing the mutex in the shared new H file.

2) Taking list.h from the 'CCAN' URL requires taking as well few other H 
files that it uses internally (e.g. build_assert.h). In few cases I 
don't see any reason to take the full file into rdma-core (e.g. 
ccan/str/str.h for stringify) will take only the needed functionality 
into list.h.

3) Need to clean up the 'CCAN' files from its include to "config.h",  in 
addition, need to consider the functionality that need to be taken when 
there are some #if HAVE_XXX internally. (see #if HAVE_TYPEOF in list.h).

4) Re the licensing disclaimer in each H file, what do you suggest to 
put ? for example minmax.h uses licenses/CC0 see 
https://github.com/rustyrussell/ccan/blob/master/ccan/minmax/LICENSE 
which is different comparing list.h which is ../../licenses/BSD-MIT.

Yishai














--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
