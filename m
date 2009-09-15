From: Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Tue, 15 Sep 2009 08:38:08 -0400
Message-ID: <003720AA-6630-4718-B7F9-8392A8422220@cisco.com>
References: <20090911064019.GZ4973@obsidianresearch.com>
	<adaljklifkt.fsf@cisco.com>
	<20090915155231.DB86.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <20090915155231.DB86.A69D9226@jp.fujitsu.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-rdma@vger.kernel.org, "Roland Dreier (rdreier)" <rdreier@cisco.com>, linux-kernel@vger.kernel.org, general@lists.openfabrics.org, Brice Goglin <Brice.Goglin@inria.fr>, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

On Sep 15, 2009, at 3:03 AM, KOSAKI Motohiro wrote:

>  - I guess you have your MPI implementaion w/ ummunotify, right?
>  - I guess you have test sevaral pattern, right?
>    if so, can we see your test result?
>


Roland's answers to the rest of these questions were spot-on, so I  
thought I'd just throw in a quick reply to the above questions: yes,  
we have a prototype Open MPI implementation with code that uses  
ummunotify (http://bitbucket.org/jsquyres/ummunot/).  I just finished  
fixing a high-priority (but unrelated) bug in Open MPI, so merging the  
prototype ummunotify code into the upstream Open MPI repository is now  
at the top of my priority list.

We have done quite a bit of testing with ummunotify, but since the  
code is not yet in the Open MPI mainline, most of the testing has been  
manual (not through our automated testing system).  As far as we can  
tell, everything is working properly with Open MPI + ummunotify.  We  
also anticipate that other MPI implementations will be able to use  
ummunotify, potentially using Open MPI as a reference ummunotify  
implementation.

FWIW: we went through a bunch of design and implementation iterations  
with Roland to get code that everyone was happy with:

- Roland likes it (and anticipated that the kernel community would be  
receptive to)
- we like it
- performs correctly

Hope that helps.

-- 
Jeff Squyres
jsquyres@cisco.com
