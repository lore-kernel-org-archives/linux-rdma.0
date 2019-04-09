From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [RFC PATCH 31/68] vfs: Convert qib_fs/ipathfs to use the new
 mount API
Date: Tue, 9 Apr 2019 13:14:58 -0400
Message-ID: <9fd8642b-952b-7ed6-6543-fe3f35b504ca@intel.com>
References: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
 <155373026764.7602.420612273283807556.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155373026764.7602.420612273283807556.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/27/2019 7:44 PM, David Howells wrote:
> Convert the qib_fs/ipathfs filesystem to the new internal mount API as the old
> one will be obsoleted and removed.  This allows greater flexibility in
> communication of mount parameters between userspace, the VFS and the
> filesystem.
> 
> See Documentation/filesystems/mount_api.txt for more information.
> 
> [Q] Can qib_remove() race with qibfs_kill_super()?  Should qib_super
>      accesses be serialised with some sort of lock?

Sure looks to be possible to me. Although I don't think that's a reason 
not to apply your patch, you aren't making it any worse I don't think.

> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
> cc: linux-rdma@vger.kernel.org

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
