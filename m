From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] add a build.sh helper to allow for a one-stop build
Date: Mon, 10 Oct 2016 09:17:11 -0700
Message-ID: <ec4f3158-a25d-7cd8-216c-fbec52577e75@acm.org>
References: <1476113282-19194-1-git-send-email-hch@lst.de>
        <c2d80cd4-74b8-8391-1855-3c666f611d91@acm.org>
        <20161010155949.GA20091@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161010155949.GA20091-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/10/16 08:59, Christoph Hellwig wrote:
> On Mon, Oct 10, 2016 at 08:56:33AM -0700, Bart Van Assche wrote:
>> Have you considered to make this script stop immediately if one of the
>> steps fails, e.g. as follows?
>
> How about just ading a
>
> set -e
>
> to the beginning to get this automatically?

That would also work. But if there is a space anywhere in the path in 
which the rdma-core repository exists, mkdir $BUILDDIR will have to be 
changed into mkdir "$BUILDDIR".

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
